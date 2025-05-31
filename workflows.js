const { Octokit } = require("@octokit/rest");

// Initialize with a personal access token (or GitHub App token)
const octokit = new Octokit({
  auth: 'YOUR_GITHUB_TOKEN'  // Replace with your token
});

async function fetchFile({ owner, repo, path, ref = 'main' }) {
  try {
    const response = await octokit.repos.getContent({
      owner,
      repo,
      path,
      ref, // Branch or tag name, default to 'main'
    });

    const content = Buffer.from(response.data.content, 'base64').toString('utf-8');
    console.log(content);
    return content;
  } catch (error) {
    console.error('Error fetching file:', error);
    throw error;
  }
}

// Example usage:
fetchFile({
  owner: 'octocat',
  repo: 'Hello-World',
  path: 'README.md',
});
