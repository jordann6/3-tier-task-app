# 3-Tier Flask Task App on AWS

This project is a simple task management application built with Flask and deployed using Docker in a 3-tier architecture. It integrates with AWS RDS for the backend database, Prometheus for monitoring, and Grafana for visualization.

## Features

- Flask-based web interface for managing tasks
- MySQL database hosted on Amazon RDS
- Prometheus for metrics scraping
- Grafana dashboard integration
- Dockerized with `docker-compose`
- Environment configuration via `.env` file

## Prerequisites

- AWS EC2 instance with Docker and Docker Compose installed
- RDS instance with public access
- Proper security group configurations
- SSH key for deployment
- `.env` file containing your secrets

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/jordann6/3-tier-task-app.git
   ```
