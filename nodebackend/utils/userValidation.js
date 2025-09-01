import Joi from 'joi';

// User creation validation schema
export const createUserSchema = Joi.object({
  username: Joi.string()
    .alphanum()
    .min(3)
    .max(30)
    .required()
    .messages({
      'string.alphanum': 'Username must contain only alphanumeric characters',
      'string.min': 'Username must be at least 3 characters long',
      'string.max': 'Username must not exceed 30 characters',
      'any.required': 'Username is required'
    }),
  
  password: Joi.string()
    .min(6)
    .max(128)
    .pattern(new RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)'))
    .required()
    .messages({
      'string.min': 'Password must be at least 6 characters long',
      'string.max': 'Password must not exceed 128 characters',
      'string.pattern.base': 'Password must contain at least one lowercase letter, one uppercase letter, and one number',
      'any.required': 'Password is required'
    }),
  
  email: Joi.string()
    .email()
    .max(255)
    .required()
    .messages({
      'string.email': 'Please provide a valid email address',
      'string.max': 'Email must not exceed 255 characters',
      'any.required': 'Email is required'
    }),
  
  role: Joi.string()
    .valid('admin', 'user', 'moderator')
    .default('user')
    .messages({
      'any.only': 'Role must be one of: admin, user, moderator'
    })
});

// User update validation schema
export const updateUserSchema = Joi.object({
  username: Joi.string()
    .alphanum()
    .min(3)
    .max(30)
    .messages({
      'string.alphanum': 'Username must contain only alphanumeric characters',
      'string.min': 'Username must be at least 3 characters long',
      'string.max': 'Username must not exceed 30 characters'
    }),
  
  password: Joi.string()
    .min(6)
    .max(128)
    .pattern(new RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)'))
    .messages({
      'string.min': 'Password must be at least 6 characters long',
      'string.max': 'Password must not exceed 128 characters',
      'string.pattern.base': 'Password must contain at least one lowercase letter, one uppercase letter, and one number'
    }),
  
  email: Joi.string()
    .email()
    .max(255)
    .messages({
      'string.email': 'Please provide a valid email address',
      'string.max': 'Email must not exceed 255 characters'
    }),
  
  role: Joi.string()
    .valid('admin', 'user', 'moderator')
    .messages({
      'any.only': 'Role must be one of: admin, user, moderator'
    })
}).min(1).messages({
  'object.min': 'At least one field must be provided for update'
});

// ID parameter validation
export const idParamSchema = Joi.object({
  id: Joi.number()
    .integer()
    .positive()
    .required()
    .messages({
      'number.base': 'User ID must be a number',
      'number.integer': 'User ID must be an integer',
      'number.positive': 'User ID must be a positive number',
      'any.required': 'User ID is required'
    })
});

// Validation middleware
export const validateCreateUser = (req, res, next) => {
  const { error, value } = createUserSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: 'Validation error',
      details: error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message
      }))
    });
  }
  req.body = value; // Use validated/transformed data
  next();
};

export const validateUpdateUser = (req, res, next) => {
  const { error, value } = updateUserSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: 'Validation error',
      details: error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message
      }))
    });
  }
  req.body = value;
  next();
};

export const validateIdParam = (req, res, next) => {
  const { error, value } = idParamSchema.validate({ id: parseInt(req.params.id) });
  if (error) {
    return res.status(400).json({
      success: false,
      message: 'Invalid user ID',
      details: error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message
      }))
    });
  }
  req.params.id = value.id;
  next();
};
