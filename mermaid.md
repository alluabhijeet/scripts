h1. Dynatrace Alerting Pipeline

{toc}

h2. 1. Flowchart Overview
Use the Mermaid macro to render the pipeline end-to-end:

{mermaid}
flowchart TD
  A1["Davis AI Anomaly Detection"] --> P["Problem"]
  A2["Custom Events/Anomaly Detectors"] --> P
  P --> B{"Can be Mapped to an Entity?"}
  B -- Yes --> C["Entity"]
  B -- No --> D["Environment Problem"]
  C --> E{shape: processes, label:"Captured via a MONACO Management Zone"}
  E --> F{shape: processes, label:"Alerting Profile Scoped to the Respective Management Zone"}
  F --> G{shape: processes, label:"Respective Problem Notification, hardcoded with the Assignment Group"}
  G --> H["ServiceNow"]
{mermaid}

h2. 2. Step-by-Step Details

|| Step || Description || Example Confluence Macro ||
| *1. Detect Anomaly* | Dynatrace’s Davis AI continuously analyzes metrics, logs and traces, while Custom Events allow you to ingest proprietary thresholds or patterns. | 
{info:title=Davis AI vs Custom Detectors}Davis AI picks up baseline deviations; Custom Events fire on your own rules.{info} |
| *2. Problem Aggregation* | All anomalies funnel into a single “Problem” object for correlation and deduplication. | |
| *3. Classification* | The Problem is evaluated:  
• Mapped to a monitored entity (host, service, container…)  
• Or treated as an environment-wide issue (e.g. network outage). | |
| *4. Scope via Management Zone* | If it’s tied to an entity, Monaco Management Zones partition problems into logical teams or applications. | {panel:title=Management Zones}Create a zone for each app/team so alerts only go to the right people.{panel} |
| *5. Alerting Profile* | Within each zone you define an Alerting Profile (severity thresholds, notification channels). | |
| *6. Notification* | Once a Problem hits the profile’s conditions, a notification is fired—with the correct Assignment Group—into ServiceNow. | {panel:title=ServiceNow Integration}Configure the “Problem notification” to use your SNOW endpoint and assignment rules.{panel} |

h2. 3. Rich Media & Attachments

# To make this page more engaging, drop in:
* !davis-ai-icon.png!  – your Davis AI logo or icon  
* !custom-detector-icon.png!  – a graphic for custom events  
* Screenshots of your Alerting Profile settings  
* Diagrams of your Management Zone structure  

h2. 4. FAQ / Troubleshooting

{expand:title=Why isn’t my Problem mapping to an Entity?}
Make sure:
* You've enabled topology detection for that host/service.
* The entity is tagged into the correct Management Zone.
{expand}

{expand:title=How do I test my ServiceNow hook?}
1. In Dynatrace, go to *Settings → Integration → ServiceNow*.  
2. Click *Test connection*.  
3. Verify in SNOW that a test incident was created under your assignment group.
{expand}

h2. 5. Related Links
* [Dynatrace Documentation: Alerting Profiles|https://www.dynatrace.com/support/help/monitor-alert/alerting-profiles]
* [Monaco Management Zones|https://www.dynatrace.com/support/help/setup-and-configuration/monaco/management-zones]
* [ServiceNow Integration|https://www.dynatrace.com/support/help/monitor-alert/service-now/]
h1. Dynatrace Alerting Pipeline

{toc}

h2. 1. Flowchart Overview
Use the Mermaid macro to render the pipeline end-to-end:

{mermaid}
flowchart TD
  A1["Davis AI Anomaly Detection"] --> P["Problem"]
  A2["Custom Events/Anomaly Detectors"] --> P
  P --> B{"Can be Mapped to an Entity?"}
  B -- Yes --> C["Entity"]
  B -- No --> D["Environment Problem"]
  C --> E{shape: processes, label:"Captured via a MONACO Management Zone"}
  E --> F{shape: processes, label:"Alerting Profile Scoped to the Respective Management Zone"}
  F --> G{shape: processes, label:"Respective Problem Notification, hardcoded with the Assignment Group"}
  G --> H["ServiceNow"]
{mermaid}

h2. 2. Step-by-Step Details

|| Step || Description || Example Confluence Macro ||
| *1. Detect Anomaly* | Dynatrace’s Davis AI continuously analyzes metrics, logs and traces, while Custom Events allow you to ingest proprietary thresholds or patterns. | 
{info:title=Davis AI vs Custom Detectors}Davis AI picks up baseline deviations; Custom Events fire on your own rules.{info} |
| *2. Problem Aggregation* | All anomalies funnel into a single “Problem” object for correlation and deduplication. | |
| *3. Classification* | The Problem is evaluated:  
• Mapped to a monitored entity (host, service, container…)  
• Or treated as an environment-wide issue (e.g. network outage). | |
| *4. Scope via Management Zone* | If it’s tied to an entity, Monaco Management Zones partition problems into logical teams or applications. | {panel:title=Management Zones}Create a zone for each app/team so alerts only go to the right people.{panel} |
| *5. Alerting Profile* | Within each zone you define an Alerting Profile (severity thresholds, notification channels). | |
| *6. Notification* | Once a Problem hits the profile’s conditions, a notification is fired—with the correct Assignment Group—into ServiceNow. | {panel:title=ServiceNow Integration}Configure the “Problem notification” to use your SNOW endpoint and assignment rules.{panel} |

h2. 3. Rich Media & Attachments

# To make this page more engaging, drop in:
* !davis-ai-icon.png!  – your Davis AI logo or icon  
* !custom-detector-icon.png!  – a graphic for custom events  
* Screenshots of your Alerting Profile settings  
* Diagrams of your Management Zone structure  

h2. 4. FAQ / Troubleshooting

{expand:title=Why isn’t my Problem mapping to an Entity?}
Make sure:
* You've enabled topology detection for that host/service.
* The entity is tagged into the correct Management Zone.
{expand}

{expand:title=How do I test my ServiceNow hook?}
1. In Dynatrace, go to *Settings → Integration → ServiceNow*.  
2. Click *Test connection*.  
3. Verify in SNOW that a test incident was created under your assignment group.
{expand}

h2. 5. Related Links
* [Dynatrace Documentation: Alerting Profiles|https://www.dynatrace.com/support/help/monitor-alert/alerting-profiles]
* [Monaco Management Zones|https://www.dynatrace.com/support/help/setup-and-configuration/monaco/management-zones]
* [ServiceNow Integration|https://www.dynatrace.com/support/help/monitor-alert/service-now/]
