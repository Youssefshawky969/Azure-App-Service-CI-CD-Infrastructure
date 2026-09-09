# Azure-App-Service-CI-CD-Infrastructure
## Situation
My goal was to build a production-ready .NET 8 Web API deployment on Azure using Infrastructure as Code and CI/CD,

## Task
I wanted to automate the provisioning and deployment process while keeping sensitive information secure and introducing separation between development and production environments with controlled promotion.

## Architecture
 I built the infrastructure using **Terraform** and hosted the .NET 8 Web API on **Azure App Service**

- The application uses **Azure SQL Database** as the production database, while **Azure Key Vault** stores the database connection string securely. 

- The App Service uses a **system-assigned managed identity** to access the secret instead of storing credentials directly in the application.

- For CI/CD, I used **Azure DevOps**. The pipeline builds the .NET application, runs tests, publishes the application, packages it as a ZIP artifact, and deploys it to App Service.

- I separated the deployment into **development and production environments**. Changes can be deployed to development automatically, while promotion to production is protected with an **approval gate**. 

- I implemented **branch security** using PR-only merges, no self-approval, mandatory Tech Lead review, branch naming enforcement through CI, and role-based permissions.

- **CI also acts as a quality gate**, ensuring changes pass the required checks before they can be merged.

- For infrastructure provisioning, I separated **Terraform Init, Plan, and Apply** and organized them using **reusable YAML templates**, making the infrastructure pipeline more consistent and maintainable.

- Overall, Terraform and Azure DevOps allow the infrastructure and application deployment to be **automated, repeatable, and controlled**, rather than relying on manual configuration.

 <img width="1253" height="621" alt="Azure project drawio" src="https://github.com/user-attachments/assets/214e97a8-0375-4f1d-9bba-2b7fbbc2f6eb" />

## Result
The final result was a fully automated Azure deployment workflow where the infrastructure is managed through Terraform and the application is built, tested, packaged, and deployed through Azure DevOps. 

- Development deployments can be automated, while production deployment requires approval. The application uses Azure SQL for persistent data and Azure Key Vault with managed identity for secure secret management.

- This gave me practical experience not only with deploying a .NET application to Azure, but also with Infrastructure as Code, CI/CD, environment promotion, secrets management, managed identities, and deployment governance.
 

