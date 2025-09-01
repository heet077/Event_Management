# 🎨 AVD Decoration Application

A comprehensive full-stack application for managing decoration events, inventory, materials, and costs. Built with **Flutter** frontend and **Node.js** backend, featuring modern architecture and robust state management.

[![Flutter](https://img.shields.io/badge/Flutter-3.6.2+-blue.svg)](https://flutter.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-ISC-blue.svg)](LICENSE)

## 🌟 Overview

AVD Decoration Application is a complete solution for decoration businesses to manage their events, track inventory, manage materials, and monitor costs. The application provides a user-friendly interface for both administrators and regular users, with comprehensive backend APIs for data management.

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter      │    │   Node.js       │    │   PostgreSQL    │
│   Frontend     │◄──►│   Backend       │◄──►│   Database      │
│   (Mobile/Web) │    │   (Express.js)  │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### **Frontend (Flutter)**
- **Cross-platform**: iOS, Android, Web
- **State Management**: Riverpod
- **UI Framework**: Material Design 3
- **Architecture**: Clean Architecture with MVVM pattern

### **Backend (Node.js)**
- **Runtime**: Node.js with Express.js
- **Database**: PostgreSQL
- **Authentication**: JWT with bcrypt
- **File Upload**: Multer for image/document handling
- **Validation**: Joi schema validation

## 🚀 Features

### **🎯 Core Functionality**
- **User Management**
  - Authentication & Authorization
  - Role-based access control (Admin/User)
  - User profiles and settings

- **Event Management**
  - Create and manage decoration events
  - Event templates and year management
  - Cover and design image uploads
  - Event cost tracking

- **Inventory Management**
  - Comprehensive inventory tracking
  - Image upload for items
  - Stock management and alerts
  - Item issuance and return system
  - Issue history tracking

- **Material Management**
  - Material inventory tracking
  - Material issuance system
  - Cost tracking per material

- **Cost Management**
  - Event cost tracking
  - Yearly cost breakdown
  - Cost document uploads
  - Financial reporting

- **Gallery Management**
  - Image organization
  - Event photo collections
  - Design portfolio

### **📱 Frontend Features**
- **Responsive Design**: Adaptive layouts for all screen sizes
- **Theme System**: Light/dark mode support
- **Modern Navigation**: Bottom navigation with intuitive routing
- **Image Handling**: Upload, preview, and management
- **Real-time Updates**: Live data synchronization
- **Offline Support**: Local data caching

### **🔧 Backend Features**
- **RESTful APIs**: Comprehensive endpoint coverage
- **File Management**: Secure file upload and storage
- **Data Validation**: Input sanitization and validation
- **Error Handling**: Comprehensive error management
- **Logging**: Detailed operation logging
- **Security**: JWT tokens, role-based access

## 📁 Project Structure

```
avd_decoration_frontend_app/
├── Frontend/                 # Flutter Application
│   ├── lib/
│   │   ├── models/          # Data models
│   │   ├── providers/       # State management
│   │   ├── services/        # API services
│   │   ├── themes/          # App theming
│   │   ├── utils/           # Utility functions
│   │   ├── views/           # UI screens
│   │   └── routes/          # App routing
│   ├── assets/              # Images and resources
│   ├── android/             # Android-specific files
│   ├── ios/                 # iOS-specific files
│   └── web/                 # Web-specific files
│
├── Backend/                  # Node.js Server
│   ├── controllers/         # Route controllers
│   ├── models/              # Database models
│   ├── routes/              # API routes
│   ├── middlewares/         # Custom middlewares
│   ├── services/            # Business logic
│   ├── config/              # Configuration files
│   ├── uploads/             # File storage
│   └── utils/               # Utility functions
│
├── docs/                    # Documentation
├── scripts/                 # Setup and utility scripts
└── README.md               # This file
```

## 🛠️ Technology Stack

### **Frontend**
- **Framework**: Flutter 3.6.2+
- **Language**: Dart 3.0.0+
- **State Management**: Riverpod 2.5.1
- **HTTP Client**: Dio 5.8.0+, HTTP 1.2.1
- **Storage**: Shared Preferences, Flutter Secure Storage
- **Image Handling**: Image Picker, Photo View
- **PDF**: PDF generation and printing
- **Navigation**: Custom routing system

### **Backend**
- **Runtime**: Node.js 18+
- **Framework**: Express.js 4.18.2
- **Database**: PostgreSQL 13+
- **ORM**: Custom query builders
- **Authentication**: JWT, bcrypt
- **File Upload**: Multer
- **Validation**: Joi
- **CORS**: Cross-origin resource sharing

### **Database**
- **Primary**: PostgreSQL
- **Features**: ACID compliance, JSON support
- **Extensions**: UUID, advanced indexing

## 📋 Prerequisites

### **System Requirements**
- **Operating System**: Windows 10+, macOS 10.15+, or Ubuntu 18.04+
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: 10GB free space
- **Network**: Internet connection for dependencies

### **Development Tools**
- **Git**: Version control
- **VS Code** or **Android Studio**: IDE with Flutter extensions
- **Postman** or **Insomnia**: API testing

### **Software Requirements**
- **Flutter SDK**: 3.6.2 or higher
- **Dart SDK**: 3.0.0 or higher
- **Node.js**: 18.0.0 or higher
- **npm** or **yarn**: Package managers
- **PostgreSQL**: 13.0 or higher

## 🚀 Quick Start

### **1. Clone the Repository**
```bash
git clone https://github.com/yourusername/avd_decoration_frontend_app.git
cd avd_decoration_frontend_app
```

### **2. Backend Setup**
```bash
cd Backend
npm install
cp .env.example .env
# Edit .env with your database credentials
npm run setup
npm run dev
```

### **3. Frontend Setup**
```bash
cd Frontend
flutter pub get
flutter run
```

### **4. Database Setup**
```bash
# Create PostgreSQL database
createdb avd_decoration_db

# Run migrations (if any)
psql -d avd_decoration_db -f Backend/setup-decorationapp.js
```

## 🔧 Configuration

### **Environment Variables**
Create `.env` files in both Frontend and Backend directories:

#### **Backend (.env)**
```env
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=avd_decoration_db
DB_USER=your_username
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret_key
UPLOAD_PATH=./uploads
```

#### **Frontend (.env)**
```env
API_BASE_URL=http://localhost:3000/api
```

### **Database Configuration**
- **Host**: localhost
- **Port**: 5432
- **Database**: avd_decoration_db
- **User**: Your PostgreSQL username
- **Password**: Your PostgreSQL password

## 📱 Usage

### **Authentication**
1. Launch the Flutter app
2. Navigate to Login screen
3. Enter credentials (admin/user)
4. Access role-based features

### **Event Management**
1. Create new events with details
2. Upload cover and design images
3. Track event costs and materials
4. Manage event templates

### **Inventory Management**
1. Add inventory items with images
2. Track stock levels
3. Issue items to users
4. Monitor return dates

### **Cost Tracking**
1. Record event expenses
2. Upload cost documents
3. Generate financial reports
4. Track yearly budgets

## 🧪 Testing

### **Frontend Testing**
```bash
cd Frontend
flutter test                    # Unit tests
flutter test test/widget_test.dart  # Widget tests
flutter drive --target=test_driver/app.dart  # Integration tests
```

### **Backend Testing**
```bash
cd Backend
npm test                       # Unit tests
npm run test:integration       # Integration tests
npm run test:coverage          # Coverage report
```

### **API Testing**
- Use Postman or Insomnia
- Import API collection from `docs/`
- Test all endpoints with sample data

## 🚀 Deployment

### **Backend Deployment**
```bash
cd Backend
npm run build
npm start
```

### **Frontend Deployment**

#### **Android APK**
```bash
cd Frontend
flutter build apk --release
flutter install
```

#### **iOS App Store**
```bash
cd Frontend
flutter build ios --release
# Archive in Xcode and upload to App Store Connect
```

#### **Web Deployment**
```bash
cd Frontend
flutter build web --release
# Deploy to Firebase Hosting, Netlify, or your web server
```

### **Production Considerations**
- **Environment Variables**: Secure production credentials
- **Database**: Production PostgreSQL instance
- **File Storage**: Cloud storage (AWS S3, Google Cloud)
- **SSL**: HTTPS certificates
- **Monitoring**: Application performance monitoring
- **Backup**: Regular database backups

## 📊 API Documentation

### **Base URL**
```
http://localhost:3000/api
```

### **Authentication**
```
POST /auth/login
POST /auth/logout
GET  /auth/profile
```

### **Events**
```
GET    /events
POST   /events
GET    /events/:id
PUT    /events/:id
DELETE /events/:id
```

### **Inventory**
```
GET    /inventory
POST   /inventory
GET    /inventory/:id
PUT    /inventory/:id
DELETE /inventory/:id
```

### **Materials**
```
GET    /materials
POST   /materials
GET    /materials/:id
PUT    /materials/:id
DELETE /materials/:id
```

### **Costs**
```
GET    /costs
POST   /costs
GET    /costs/:id
PUT    /costs/:id
DELETE /costs/:id
```

For detailed API documentation, see [Backend/API_DOCUMENTATION.md](Backend/API_DOCUMENTATION.md)

## 🔐 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Role-based Access Control**: Admin and user permissions
- **Input Validation**: Request sanitization and validation
- **SQL Injection Prevention**: Parameterized queries
- **File Upload Security**: File type and size validation
- **HTTPS**: Secure communication (production)
- **Password Hashing**: bcrypt encryption

## 📈 Performance Optimization

### **Frontend**
- **Lazy Loading**: On-demand widget loading
- **Image Caching**: Efficient image management
- **State Management**: Optimized Riverpod providers
- **Memory Management**: Proper disposal of resources

### **Backend**
- **Database Indexing**: Optimized query performance
- **Connection Pooling**: Efficient database connections
- **File Compression**: Optimized file handling
- **Caching**: Redis integration (optional)

## 🐛 Troubleshooting

### **Common Issues**

#### **Frontend**
1. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Dependency Issues**
   ```bash
   flutter doctor
   flutter pub deps
   ```

#### **Backend**
1. **Database Connection**
   ```bash
   # Check PostgreSQL service
   sudo systemctl status postgresql
   
   # Test connection
   psql -h localhost -U username -d database_name
   ```

2. **Port Conflicts**
   ```bash
   # Check port usage
   netstat -tulpn | grep :3000
   
   # Kill process using port
   kill -9 <PID>
   ```

### **Debug Mode**
```bash
# Frontend
flutter run --debug

# Backend
NODE_ENV=development npm run dev
```

### **Logs**
- **Frontend**: Flutter DevTools
- **Backend**: Console logs and log files
- **Database**: PostgreSQL logs

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### **Development Guidelines**
- Follow Flutter and Dart style guides
- Use meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Follow the existing code structure

### **Code Style**
- **Frontend**: Flutter lint rules
- **Backend**: ESLint configuration
- **Database**: PostgreSQL naming conventions

## 📄 License

This project is licensed under the **ISC License** - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Frontend Development**: Flutter Team
- **Backend Development**: Node.js Team
- **Database Design**: Database Team
- **UI/UX Design**: Design Team
- **Project Management**: PM Team

## 📞 Support & Contact

### **Getting Help**
- 📖 **Documentation**: Check the docs folder
- 🐛 **Issues**: Create an issue on GitHub
- 💬 **Discussions**: Use GitHub Discussions
- 📧 **Email**: contact@avddecoration.com

### **Community**
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and community support
- **Wiki**: Additional documentation and guides

## 🔄 Version History

- **v2.0.0** - Full-stack application with Flutter frontend and Node.js backend
- **v1.5.0** - Enhanced inventory management and cost tracking
- **v1.0.0** - Initial release with basic functionality

## 🎯 Roadmap

### **Upcoming Features**
- [ ] Real-time notifications
- [ ] Advanced reporting dashboard
- [ ] Mobile app store deployment
- [ ] Cloud file storage integration
- [ ] Multi-language support
- [ ] Advanced analytics

### **Long-term Goals**
- [ ] AI-powered cost optimization
- [ ] Integration with accounting software
- [ ] Customer portal
- [ ] Vendor management system
- [ ] Advanced inventory forecasting

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Node.js Community** for backend tools and libraries
- **PostgreSQL Team** for the robust database
- **Open Source Contributors** for various packages used


<div align="center">

**⭐ Star this repository if you find it helpful!**

[![GitHub stars](https://img.shields.io/github/stars/yourusername/avd_decoration_frontend_app.svg?style=social&label=Star)](https://github.com/yourusername/avd_decoration_frontend_app)
[![GitHub forks](https://img.shields.io/github/forks/yourusername/avd_decoration_frontend_app.svg?style=social&label=Fork)](https://github.com/yourusername/avd_decoration_frontend_app)
[![GitHub issues](https://img.shields.io/github/issues/yourusername/avd_decoration_frontend_app.svg)](https://github.com/yourusername/avd_decoration_frontend_app/issues)

</div>
