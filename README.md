# The Security Resume Project
##  _A security-minded take on the Cloud Resume Challenge_
---

## About
After my son was born, I needed an easy project to take on in my free time, so I tried out [The Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/), which was great, but I felt like it didn't really create a good reflection of the skills required to be a security engineer in the cloud, so I decided to adjust it to fit my needs.  The original 16 steps are based off of the Cloud Resume's challenge and try to stay within the spirit of the challenge.  Extra, more advanced, challenges have been listed afterwards as a way to continue improving

## The Challenge
1. Certification: Obtain the AWS Security Specialty certication
2. HTML: Write a resume in HTML
3. CSS: Style the resume with CSS
4. Static Website: Host the website using an Amazon S3 static website.
5. HTTPS: Use Amazon CloudFront to provide an SSL certificate for your website
6. DNS: Register a domain name and use Amazon Route 53 to point your domain name at your website
7. Logging: Create a second S3 bucket with a retention policy to hold logs from the S3 static website
8. Python: Write a lambda that triggers when new logs are added to the bucket to retrieve the IP address of the person requesting the site
9. Database: Set up a DynamoDB database for the lambda to log all the visitor IP addresses too
10. Tests: Write tests for the python script used in the Lambda
11. Infrastructure as Code: Create Terraform or CloudFormation templates to automatically deploy your infrastructure
12. Source Control: Store all of your files for the website in a Github Repo, divide them up by backend and frontend
13. CI/CD (back end): Implement a CI/CD pipeline using Github Actions so that whenever the terraform or lambda is changed, the changes are automatically pushed up to AWS
14. CI/CD (front end): Implement a CI/CD pipeline using Github Actions so that whenever your HTML or CSS files are updated, they are automatically pushed to the S3 bucket and the CloudFront cache is invalidated
15. Notifications: Set up a lambda and SNS pipeline so that whenever a number of people that you feel is appropriate visit your website, you get a notification of it
16. Blog Post: Write a blog post detailing what you learned.

## Extras
17. Lambda Pt. II: Adjust the lambdas so that the IP addresses of web crawlers are stored, but not counted.
18. Notifications Pt. II: 
19. Multi-cloud Pt. I: Deploy the same resources to GCP, replicate the databases, and apply with terraform
20. Multi-cloud Pt. II: Deploy the same resources to Azure, replicate the databases, and apply with terraform
21. Monitoring: Perform Geolocation on IP Addresses to find where requests are coming from and notify if coming from desirable geographic location

# To Do
1. ~~Enable bucket/Cloudfront logging to get visitors to website~~
2. Trigger lambda based off data added to S3 bucket to add IP address to DynamoDB database
3. Send a notification via SNS when a new visitor goes to the site
4. Deploy everything with terraform and a Github action
5. ~~Set up retention policy on logging bucket to prevent high costs~~
6. Clean up old resources in AWS