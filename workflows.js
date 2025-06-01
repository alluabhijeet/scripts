const { Octokit } = require("@octokit/rest");

const octokit = new Octokit({
  auth: 'YOUR_GITHUB_TOKEN', // Replace with your GitHub token
  baseUrl: 'https://github.yourcompany.com/api/v3', // Replace for GitHub Enterprise
});

async function createBranchAndUpdateFile({
  owner,
  repo,
  baseBranch = 'main',
  newBranch,
  filePath,
  fileContent,
  commitMessage,
}) {
  try {
    // 1. Get the SHA of the base branch
    const { data: baseRefData } = await octokit.git.getRef({
      owner,
      repo,
      ref: `heads/${baseBranch}`,
    });

    const baseSha = baseRefData.object.sha;

    // 2. Create new branch from base SHA
    await octokit.git.createRef({
      owner,
      repo,
      ref: `refs/heads/${newBranch}`,
      sha: baseSha,
    });

    console.log(`Branch '${newBranch}' created from '${baseBranch}'`);

    // 3. Get the current file (to get the SHA if it exists)
    let fileSha;
    try {
      const { data: fileData } = await octokit.repos.getContent({
        owner,
        repo,
        path: filePath,
        ref: newBranch,
      });
      fileSha = fileData.sha; // File exists
    } catch (err) {
      if (err.status !== 404) throw err; // Only ignore file-not-found
    }

    // 4. Update or create the file
    await octokit.repos.createOrUpdateFileContents({
      owner,
      repo,
      path: filePath,
      message: commitMessage,
      content: Buffer.from(fileContent).toString('base64'),
      branch: newBranch,
      sha: fileSha, // include only if file exists
    });

    console.log(`File '${filePath}' updated on branch '${newBranch}'`);
  } catch (error) {
    console.error('Error during branch or file update:', error);
    throw error;
  }
}

// ✅ Example usage
createBranchAndUpdateFile({
  owner: 'your-org',
  repo: 'your-repo',
  baseBranch: 'main',
  newBranch: 'feature/update-config',
  filePath: 'config/settings.yaml',
  fileContent: 'key: updated-value\nanotherKey: true\n',
  commitMessage: 'Update settings.yaml in new branch',
});
