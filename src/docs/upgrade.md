# Updating Core WAAP Operator

To run a newer version of the Core WAAP Operator the corresponding helm chart can be used. Please check in the release notes what has changed and which setting may affect your deployed CoreWaapServices. In case of breaking changes, it is recommended to follow these instructions:

1. Stop the Core WAAP Operator by scaling the deployment down to 0 replicas.
2. Update the Core WAAP Operator by installing the new helm chart (ensure the CoreWaapService CustomResourceDefinition was updated.)
3. Align the CoreWaapServices with the new schema according to the breaking changes in the release notes.
4. Scale up the Core WAAP Operator deployment to 1 replica.
5. Check the Core WAAP Operator Logs, to ensure that no error due to incompatibility occurs. Fix the remaining issues in the CoreWaapServices Custom Resources if required.

**Note:** This procedure should prevent any downtime of a CoreWaapService. In case also a new Core WAAP Version is set, the pods will restart accordingly.