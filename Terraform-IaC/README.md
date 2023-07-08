# House Prediction Serverless Model IaC

Infrastructure for Flask & Nginx server.
Where Nginx server will listen on port 80 and pass all the traffic to flast app, which is running on port *5000*

### Follow below steps to configure Nginx

Nginx will listen on port 80 according to our configuration and send those data to flask app

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
