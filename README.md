# luxury

Multi-Vendor E-Commerce Application
A cross-platform, multi-vendor e-commerce platform built with a serverless architecture using Firebase for a scalable, real-time backend.

## Introduction
This project is a multi-vendor e-commerce application designed to allow multiple sellers (vendors) to register and sell their products on a single platform. It utilizes Firebase for all backend operations, including user authentication, real-time database, and file storage.

## Features
Authentication & User Management
Dual Sign-In: Separate login paths for Vendors and Customers.

User Profiles: Both vendors and customers can view and edit their respective profiles.

Order History: Customers can view their purchase history (Feature planned for imminent addition: "will be added soon").

 ![Image Alt](https://github.com/Moumel/multi_vendor_E-commerce/blob/main/app%20images/Picsart_25-10-15_01-04-25-956.jpg?raw=true)

## Customer Interface
Top Bar: Displays the app name, an application icon, and a cart badge showing the number of items.

Search & Filtering: A dedicated search bar with quick filters for Men, Women, and Kids categories.

Product View: Displays item image, price, and name with an "Add to Cart" button. Clicking an item opens a dedicated product details page.

Bottom Navigation: Easy access to the Cart Page and User Profile.

![Image Alt](https://github.com/Moumel/multi_vendor_E-commerce/blob/b6be67eac73f677ed3c11ce85edfa70c1657ccb8/app%20images/Picsart_25-10-15_01-14-41-554.jpg)

## Vendor Dashboard
Item Management: Vendors have a dashboard to add new products, including the item image, price, and name.

Vendor Profile: Similar profile editing capabilities as customers.

![Image Alt](https://github.com/Moumel/multi_vendor_E-commerce/blob/7834a33734e6c70da4fd403d4b7a323df1b265a9/app%20images/unnamed.jpg)

## Technology Stack
This application relies entirely on Firebase for its backend services, allowing for faster development and easier scalability.

## Getting Started

Create a Firebase Project:

Go to the Firebase Console and create a new project.

Register App: Android, or iOS app (depending on your frontend).

Add Configuration to App


## Setup Database Rules:

For the application to function correctly, you will need to set up security rules in your Firebase console to handle vendor/customer roles and permissions (e.g., only vendors can write to the /products collection).


## By
Moamel Al-gabri
