# House Prediction Serverless Application

This project aims to deploy a trained model for predicting house prices using a **serverless function** behind **Azure API Management**, as opposed to a virtual machine. The web application is deployed on a virtual machine provisioned using Terraform, with manual configurations.

The house price dataset was downloaded from Kaggle and uploaded to **Azure Machine Learning Studio**. Automated training options were used to train the dataset on multiple algorithms. The resulting model was then converted into pickle format and deployed locally for testing before being pushed to the serverless function in the cloud.


### Some Important Notes.
> Python=3.10 Version was used.

> banglore_home_prices_lr_trained_model.pickle(Inside Website folder) == bundled_model.pkl(Inside Azure function folder) are same

---
# House Prediction Serverless Model IaC

Infrastructure for Flask & Nginx server.
Where Nginx server will listen on port 80 and pass all the traffic to flast app, which is running on port *5000*

### Follow below steps to configure Nginx

Nginx will listen on port 80 according to our configuration and send received data from client to flask app running on port *5000*

To set up NGINX as a proxy between the user and your application's front and back end, follow the instructions below:

1. Update the package list on your system:
```
sudo apt-get update
```

2. Install NGINX:
```
sudo apt-get install nginx
```

3. Start the NGINX service:
```
sudo service nginx start
```

4. Configure NGINX to point to your web application. Create a new file called `bhp.conf` in the `/etc/nginx/sites-available` directory using the following command:
```
sudo vim /etc/nginx/sites-available/bhp.conf
```
You can find `bhp.conf` file in Nginx Folder

Please note that the above instructions assume you have administrative privileges on your system. Make sure to replace `bhp.conf` with the appropriate configuration file name for your specific application.
