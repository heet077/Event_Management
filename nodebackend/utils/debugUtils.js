import fs from 'fs';
import path from 'path';

// Debug configuration
export const DebugConfig = {
  ENABLED: process.env.DEBUG === 'true' || process.env.NODE_ENV === 'development',
  LOG_LEVEL: process.env.LOG_LEVEL || 'info', // debug, info, warn, error
  MAX_LOG_SIZE: 1000, // Maximum number of log entries to keep in memory
  LOG_TO_FILE: process.env.LOG_TO_FILE === 'true'
};

// Log levels
export const LogLevel = {
  DEBUG: 0,
  INFO: 1,
  WARN: 2,
  ERROR: 3
};

// In-memory log storage
let logBuffer = [];

// Debug logger
export const debugLog = (level, message, data = {}) => {
  if (!DebugConfig.ENABLED) return;
  
  const timestamp = new Date().toISOString();
  const logEntry = {
    timestamp,
    level,
    message,
    data,
    pid: process.pid
  };
  
  // Add to buffer
  logBuffer.push(logEntry);
  
  // Keep buffer size manageable
  if (logBuffer.length > DebugConfig.MAX_LOG_SIZE) {
    logBuffer = logBuffer.slice(-DebugConfig.MAX_LOG_SIZE);
  }
  
  // Console output based on log level
  const levelNames = ['DEBUG', 'INFO', 'WARN', 'ERROR'];
  const emoji = ['🔍', 'ℹ️', '⚠️', '❌'];
  
  console.log(`${emoji[level]} [${levelNames[level]}] ${message}`);
  
  if (Object.keys(data).length > 0) {
    console.log('📋 Data:', JSON.stringify(data, null, 2));
  }
  
  // Write to file if enabled
  if (DebugConfig.LOG_TO_FILE) {
    writeLogToFile(logEntry);
  }
};

// File system debug utilities
export const debugFileSystem = {
  // Check file existence and stats
  inspectFile: (filePath) => {
    try {
      const absolutePath = path.resolve(filePath);
      const exists = fs.existsSync(filePath);
      const stats = exists ? fs.statSync(filePath) : null;
      
      debugLog(LogLevel.DEBUG, `File inspection: ${filePath}`, {
        absolutePath,
        exists,
        size: stats?.size,
        permissions: stats?.mode.toString(8),
        lastModified: stats?.mtime,
        isDirectory: stats?.isDirectory(),
        isFile: stats?.isFile()
      });
      
      return { exists, stats, absolutePath };
    } catch (error) {
      debugLog(LogLevel.ERROR, `File inspection failed: ${filePath}`, { error: error.message });
      return { exists: false, error: error.message };
    }
  },
  
  // Check directory contents
  inspectDirectory: (dirPath) => {
    try {
      const absolutePath = path.resolve(dirPath);
      const exists = fs.existsSync(dirPath);
      const contents = exists ? fs.readdirSync(dirPath) : [];
      
      debugLog(LogLevel.DEBUG, `Directory inspection: ${dirPath}`, {
        absolutePath,
        exists,
        itemCount: contents.length,
        contents: contents.slice(0, 10) // Show first 10 items
      });
      
      return { exists, contents, absolutePath };
    } catch (error) {
      debugLog(LogLevel.ERROR, `Directory inspection failed: ${dirPath}`, { error: error.message });
      return { exists: false, error: error.message };
    }
  },
  
  // Check disk space
  checkDiskSpace: (dirPath) => {
    try {
      const stats = fs.statSync(dirPath);
      // Note: This is a simplified check. For production, consider using a proper disk space library
      debugLog(LogLevel.DEBUG, `Disk space check for: ${dirPath}`, {
        directory: dirPath,
        // Add more disk space info if needed
      });
      
      return { available: true };
    } catch (error) {
      debugLog(LogLevel.ERROR, `Disk space check failed: ${dirPath}`, { error: error.message });
      return { available: false, error: error.message };
    }
  }
};



// Network debug utilities
export const debugNetwork = {
  // Debug HTTP requests
  debugHttpRequest: (url, method, headers = {}) => {
    debugLog(LogLevel.DEBUG, `HTTP Request: ${method} ${url}`, {
      url,
      method,
      headers: Object.keys(headers),
      timestamp: new Date().toISOString()
    });
  },
  
  // Debug HTTP responses
  debugHttpResponse: (url, status, headers = {}) => {
    debugLog(LogLevel.DEBUG, `HTTP Response: ${status} for ${url}`, {
      url,
      status,
      statusText: getStatusText(status),
      headers: Object.keys(headers),
      timestamp: new Date().toISOString()
    });
  }
};

// Performance debug utilities
export const debugPerformance = {
  timers: new Map(),
  
  // Start timing an operation
  startTimer: (operation) => {
    const timerId = `${operation}_${Date.now()}`;
    debugPerformance.timers.set(timerId, {
      operation,
      startTime: Date.now(),
      startHrTime: process.hrtime()
    });
    
    debugLog(LogLevel.DEBUG, `Timer started: ${operation}`, { timerId });
    return timerId;
  },
  
  // End timing an operation
  endTimer: (timerId) => {
    const timer = debugPerformance.timers.get(timerId);
    if (!timer) {
      debugLog(LogLevel.WARN, `Timer not found: ${timerId}`);
      return null;
    }
    
    const endTime = Date.now();
    const endHrTime = process.hrtime(timer.startHrTime);
    const duration = endTime - timer.startTime;
    const durationHr = (endHrTime[0] * 1000 + endHrTime[1] / 1000000).toFixed(2);
    
    debugLog(LogLevel.INFO, `Timer completed: ${timer.operation}`, {
      operation: timer.operation,
      duration: `${duration}ms`,
      durationHr: `${durationHr}ms`,
      timerId
    });
    
    debugPerformance.timers.delete(timerId);
    return { duration, durationHr };
  }
};

// Memory debug utilities
export const debugMemory = {
  // Get memory usage
  getMemoryUsage: () => {
    const usage = process.memoryUsage();
    debugLog(LogLevel.DEBUG, 'Memory usage', {
      rss: `${Math.round(usage.rss / 1024 / 1024)}MB`,
      heapTotal: `${Math.round(usage.heapTotal / 1024 / 1024)}MB`,
      heapUsed: `${Math.round(usage.heapUsed / 1024 / 1024)}MB`,
      external: `${Math.round(usage.external / 1024 / 1024)}MB`
    });
    return usage;
  },
  
  // Check for memory leaks
  checkMemoryLeak: () => {
    const usage = process.memoryUsage();
    const heapUsedMB = usage.heapUsed / 1024 / 1024;
    
    if (heapUsedMB > 500) { // Warning at 500MB
      debugLog(LogLevel.WARN, 'High memory usage detected', {
        heapUsed: `${Math.round(heapUsedMB)}MB`,
        threshold: '500MB'
      });
    }
    
    return heapUsedMB;
  }
};

// Utility functions
const getStatusText = (status) => {
  const statusTexts = {
    200: 'OK',
    201: 'Created',
    400: 'Bad Request',
    401: 'Unauthorized',
    403: 'Forbidden',
    404: 'Not Found',
    500: 'Internal Server Error',
    502: 'Bad Gateway',
    503: 'Service Unavailable'
  };
  return statusTexts[status] || 'Unknown';
};

const writeLogToFile = (logEntry) => {
  try {
    const logDir = './logs';
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }
    
    const logFile = path.join(logDir, `debug-${new Date().toISOString().split('T')[0]}.log`);
    const logLine = JSON.stringify(logEntry) + '\n';
    
    fs.appendFileSync(logFile, logLine);
  } catch (error) {
    console.error('Failed to write log to file:', error.message);
  }
};

// Export convenience functions
export const debug = (message, data) => debugLog(LogLevel.DEBUG, message, data);
export const info = (message, data) => debugLog(LogLevel.INFO, message, data);
export const warn = (message, data) => debugLog(LogLevel.WARN, message, data);
export const error = (message, data) => debugLog(LogLevel.ERROR, message, data);

// Get all logs (for debugging purposes)
export const getLogs = () => [...logBuffer];

// Clear logs
export const clearLogs = () => {
  logBuffer = [];
  debugLog(LogLevel.INFO, 'Log buffer cleared');
};

// Export debug configuration
export const getDebugConfig = () => ({ ...DebugConfig }); 