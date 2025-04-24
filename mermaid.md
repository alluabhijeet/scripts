
```mermiad
flowchart TD
    P["Problem"]
    A1["Davis AI Anomaly Detection"] --> P
    A2["Custom Events/Anomaly Detectors"] --> P
    P -->B["Can be Mapped to an Entity?"]

    B -- Yes --> C["Entity"]
    B -- No --> D["Environment Problem"]

    C --> E@{ shape: processes, label: "Captured via a MONACO Management Zone"}
  
    E --> F@{ shape: processes, label: "Alerting Profile Scoped to the Respective Management Zone"}
    F --> G@{ shape: processes, label: "Respective Problem Notification, hardcoded with the Assignment Group"}
    G --> H["ServiceNow"]
```
