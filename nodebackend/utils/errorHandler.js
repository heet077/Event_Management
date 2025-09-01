import fs from 'fs';
import path from 'path';

// Error types for better categorization
export const ErrorTypes = {
  AUTHENTICATION: 'AUTHENTICATION_ERROR',
  FILE_NOT_FOUND: 'FILE_NOT_FOUND',
  FILE_TOO_LARGE: 'FILE_TOO_LARGE',
  INVALID_FILE_TYPE: 'INVALID_FILE_TYPE',
  PERMISSION_DENIED: 'PERMISSION_DENIED',
  NETWORK_ERROR: 'NETWORK_ERROR',
  STORAGE_QUOTA: 'STORAGE_QUOTA_ERROR',

  FILE_SYSTEM: 'FILE_SYSTEM_ERROR',
  VALIDATION: 'VALIDATION_ERROR',
  UNKNOWN: 'UNKNOWN_ERROR'
};

// Enhanced error class with additional context
export class FileOperationError extends Error {
  constructor(message, type = ErrorTypes.UNKNOWN, details = {}) {
    super(message);
    this.name = 'FileOperationError';
    this.type = type;
    this.details = details;
    this.timestamp = new Date().toISOString();
  }
}

// Error handler for file operations
export const handleFileError = (error, operation, filePath = null) => {
  console.error(`❌ File operation error in ${operation}:`, error.message);
  
  if (filePath) {
    console.error(`📁 File path: ${filePath}`);
    
    // Check if file exists
    try {
      if (fs.existsSync(filePath)) {
        const stats = fs.statSync(filePath);
        console.error(`📄 File exists, size: ${stats.size} bytes`);
      } else {
        console.error(`📄 File does not exist`);
      }
    } catch (statsError) {
      console.error(`📄 Error checking file stats: ${statsError.message}`);
    }
  }
  
  if (error.stack) {
    console.error('Stack trace:', error.stack);
  }
  
  // Categorize error
  let errorType = ErrorTypes.UNKNOWN;
  let userMessage = error.message;
  
  if (error.code === 'ENOENT') {
    errorType = ErrorTypes.FILE_NOT_FOUND;
    userMessage = 'File not found';
  } else if (error.code === 'EACCES') {
    errorType = ErrorTypes.PERMISSION_DENIED;
    userMessage = 'Permission denied';
  } else if (error.code === 'ENOSPC') {
    errorType = ErrorTypes.FILE_SYSTEM;
    userMessage = 'No space left on device';
  } else if (error.message.includes('too large')) {
    errorType = ErrorTypes.FILE_TOO_LARGE;
    userMessage = 'File is too large';
  } else if (error.message.includes('invalid file type')) {
    errorType = ErrorTypes.INVALID_FILE_TYPE;
    userMessage = 'Invalid file type';
  }
  
  return {
    error: true,
    type: errorType,
    message: userMessage,
    originalError: error.message,
    operation,
    filePath,
    timestamp: new Date().toISOString()
  };
};


  }
  
  return {
    error: true,
    type: errorType,
    message: userMessage,
    originalError: error.message,
    operation,
    fileId,
    code: error.code,
    timestamp: new Date().toISOString()
  };
};

// File validation utility
export const validateFile = (filePath, options = {}) => {
  const {
    maxSize = 100 * 1024 * 1024, // 100MB default
    allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'],
    checkExists = true
  } = options;
  
  try {
    // Check if file exists
    if (checkExists && !fs.existsSync(filePath)) {
      return {
        valid: false,
        error: 'File does not exist',
        type: ErrorTypes.FILE_NOT_FOUND
      };
    }
    
    // Get file stats
    const stats = fs.statSync(filePath);
    
    // Check file size
    if (stats.size === 0) {
      return {
        valid: false,
        error: 'File is empty',
        type: ErrorTypes.VALIDATION
      };
    }
    
    if (stats.size > maxSize) {
      return {
        valid: false,
        error: `File too large: ${stats.size} bytes (max: ${maxSize} bytes)`,
        type: ErrorTypes.FILE_TOO_LARGE,
        size: stats.size,
        maxSize
      };
    }
    
    // Check file extension
    const ext = path.extname(filePath).toLowerCase();
    if (!allowedExtensions.includes(ext)) {
      return {
        valid: false,
        error: `Invalid file extension: ${ext}`,
        type: ErrorTypes.INVALID_FILE_TYPE,
        extension: ext,
        allowedExtensions
      };
    }
    
    return {
      valid: true,
      size: stats.size,
      extension: ext,
      lastModified: stats.mtime
    };
    
  } catch (error) {
    return {
      valid: false,
      error: error.message,
      type: ErrorTypes.FILE_SYSTEM
    };
  }
};

// Safe file cleanup utility
export const safeFileCleanup = (filePath) => {
  try {
    if (filePath && fs.existsSync(filePath)) {
      const stats = fs.statSync(filePath);
      fs.unlinkSync(filePath);
      console.log(`🗑️ Cleaned up file: ${filePath} (${stats.size} bytes)`);
      return true;
    }
  } catch (error) {
    console.error(`❌ Error cleaning up file ${filePath}:`, error.message);
    return false;
  }
  return false;
};

// Directory cleanup utility
export const cleanupTempDirectory = (dirPath, maxAge = 24 * 60 * 60 * 1000) => { // 24 hours
  try {
    if (!fs.existsSync(dirPath)) {
      return { cleaned: 0, errors: 0 };
    }
    
    const files = fs.readdirSync(dirPath);
    let cleaned = 0;
    let errors = 0;
    const now = Date.now();
    
    for (const file of files) {
      const filePath = path.join(dirPath, file);
      try {
        const stats = fs.statSync(filePath);
        
        // Remove files older than maxAge
        if (now - stats.mtime.getTime() > maxAge) {
          fs.unlinkSync(filePath);
          cleaned++;
          console.log(`🗑️ Cleaned up old temp file: ${filePath}`);
        }
      } catch (error) {
        console.error(`❌ Error processing temp file ${filePath}:`, error.message);
        errors++;
      }
    }
    
    console.log(`🧹 Temp directory cleanup: ${cleaned} files removed, ${errors} errors`);
    return { cleaned, errors };
    
  } catch (error) {
    console.error(`❌ Error cleaning up temp directory ${dirPath}:`, error.message);
    return { cleaned: 0, errors: 1 };
  }
};

// Error response formatter
export const formatErrorResponse = (error, operation = 'unknown') => {
  const timestamp = new Date().toISOString();
  
  return {
    success: false,
    error: {
      message: error.message || 'An unknown error occurred',
      type: error.type || ErrorTypes.UNKNOWN,
      operation,
      timestamp,
      details: error.details || {}
    }
  };
};

// Success response formatter
export const formatSuccessResponse = (data, operation = 'unknown') => {
  const timestamp = new Date().toISOString();
  
  return {
    success: true,
    data,
    operation,
    timestamp
  };
}; 