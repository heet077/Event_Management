# 🎨 Decoration App - Event Management System

A comprehensive backend system for managing decoration events and images with local file storage.

## 🚀 Features

- **Event Management**: Create and manage decoration events
- **Image Upload**: Upload design and final decoration images
- **Local File Storage**: Secure local file storage with organized folder structure
- **Database Storage**: PostgreSQL database for data persistence
- **RESTful API**: Complete REST API for frontend integration

## 📁 Project Structure

```
decoration-app/
├── config/
│   └── db.js                 # Database configuration
├── controllers/
│   ├── auth.controller.js    # Authentication logic
│   ├── event.controller.js   # Event management
│   ├── gallery.controller.js # Image handling
│   └── ...                   # Other controllers
├── models/
│   ├── event.model.js        # Event database operations
│   ├── gallery.model.js      # Image database operations
│   └── ...                   # Other models
├── routes/
│   ├── auth.routes.js        # Authentication endpoints
│   ├── event.routes.js       # Event endpoints
│   ├── gallery.routes.js     # Image upload endpoints
│   └── ...                   # Other routes
├── services/
│   ├── event.service.js      # Event business logic
│   └── ...                   # Other services
├── utils/
│   ├── token.js              # JWT token handling
│   └── ...                   # Other utilities
├── middlewares/
│   ├── upload.js             # File upload middleware
│   ├── errorHandler.js       # Error handling middleware
│   └── ...                   # Other middlewares
├── app.js                    # Express app configuration
├── server.js                 # Server entry point
└── package.json              # Dependencies
```

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd decoration-app
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```



5. **Set up database**
   ```bash
   # Create PostgreSQL database
   createdb decorationdb
   
   # Run migrations (if available)
   npm run migrate
   ```

6. **Start the server**
   ```bash
   npm start
   # or for development
   npm run dev
   ```

## 🔧 Configuration

### Environment Variables (.env)
```env
# Server
PORT=5000
NODE_ENV=development

# Database
DATABASE_URL=postgresql://username:password@localhost:5432/decorationdb
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=password
DB_NAME=decorationdb

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=24h


```

## 📡 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/profile` - Get user profile

### Events
- `GET /api/events` - List all events
- `POST /api/events` - Create new event
- `GET /api/events/:id` - Get event details
- `PUT /api/events/:id` - Update event
- `DELETE /api/events/:id` - Delete event

### Gallery (Images)
- `POST /api/gallery/design` - Upload design image
- `POST /api/gallery/final` - Upload final decoration image
- `GET /api/gallery/:event_id` - Get event images


## 🎯 Usage Examples

### Upload Design Image
```bash
curl -X POST http://localhost:5000/api/gallery/design \
  -F "image=@design.jpg" \
  -F "event_id=1" \
  -F "notes=Initial design concept"
```

### Upload Final Image with URL
```bash
curl -X POST http://localhost:5000/api/gallery/final \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "description": "Final decoration result",
    "image_url": "https://example.com/image.jpg"
  }'
```

### Get Event Images
```bash
curl http://localhost:5000/api/gallery/1
```

## 📁 Local File Storage

### Folder Structure
```
uploads/
├── events/
│   └── 1/
│       ├── cover_image_1.jpg
│       ├── design_images/
│       │   └── design_images_1.jpg
│       └── final_images/
│           └── final_images_1.jpg
└── inventory/
    ├── furniture/
    ├── fabric/
    ├── frame-structures/
    ├── carpets/
    ├── thermocol/
    ├── stationery/
    └── murti-sets/
```

### File Organization
- **Events**: Each event gets its own folder with organized subfolders
- **Inventory**: Materials are organized by category with item-specific folders
- **Security**: Files are stored locally with proper access controls

## 🧪 Testing

### Test API Endpoints
```bash
# Test server
curl http://localhost:5000/api/gallery/test
```

## 🚨 Troubleshooting

### File Storage Issues
1. **Disk Space**: Ensure sufficient disk space for uploads
   - **Solution**: Monitor disk usage and clean up old files

2. **Permissions**: Check file system permissions
   - **Solution**: Ensure uploads directory is writable

3. **File Size**: Large files may exceed limits
   - **Solution**: Check multer configuration for file size limits

### Database Issues
1. **Connection**: Check database credentials
   - **Solution**: Verify `.env` configuration

2. **Tables**: Ensure tables exist
   - **Solution**: Run database migrations

## 🔒 Security

- **JWT Authentication**: Secure user authentication
- **Input Validation**: All inputs are validated
- **Error Handling**: Comprehensive error handling
- **File Upload**: Secure file upload with validation

## 📊 Database Schema

### Events Table
```sql
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  date DATE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Design Images Table
```sql
CREATE TABLE design_images (
  id SERIAL PRIMARY KEY,
  event_id INTEGER REFERENCES events(id),
  image_url TEXT NOT NULL,
  notes TEXT,
  timestamp TIMESTAMP DEFAULT NOW()
);
```

### Final Images Table
```sql
CREATE TABLE final_decoration_images (
  id SERIAL PRIMARY KEY,
  event_id INTEGER REFERENCES events(id),
  image_url TEXT NOT NULL,
  description TEXT,
  timestamp TIMESTAMP DEFAULT NOW()
);
```

## 🚀 Deployment

### Production Setup
1. **Environment**: Set `NODE_ENV=production`
2. **Database**: Use production PostgreSQL instance
3. **File Storage**: Ensure sufficient disk space and backup strategy
4. **SSL**: Configure HTTPS
5. **Monitoring**: Set up logging and monitoring

### Docker Deployment
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 5000
CMD ["npm", "start"]
```

## 📝 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the troubleshooting section

---

**🎨 Decoration App** - Making event decoration management simple and efficient!
