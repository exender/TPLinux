#!/bin/bash

# BONNIN BAPTISTE
# 05/10/2020
# script d'install pour les outils prérequis

yum update -y

yum install vim -y
yum install epel-release -y
yum install nginx -y
yum install tree -y