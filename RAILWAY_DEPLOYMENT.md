# 🚀 Railway Deployment Guide - AI Agent Service

## Overview

This guide will help you deploy your AI Agent Service to Railway, which is perfect for the Telegram Premium Chatbot feature workflow.

## 🎯 Telegram Premium Chatbot Workflow

Your service supports the complete Telegram Premium Chatbot workflow:

1. **User creates bot** with @BotFather
2. **User pastes bot token** in your dashboard
3. **AI Agent Service validates** and configures the bot
4. **User enables Premium Chatbot** in Telegram Business settings
5. **Bot automatically responds** in private chats

## 🚀 Railway Deployment Steps

### Step 1: Prepare Your Repository

1. **Push your code to GitHub:**
   ```bash
   git add .
   git commit -m "Production ready AI Agent Service"
   git push origin main
   ```

### Step 2: Deploy to Railway

1. **Go to [Railway.app](https://railway.app)**
2. **Sign up with GitHub**
3. **Click "New Project"**
4. **Select "Deploy from GitHub repo"**
5. **Choose your AI Agent Service repository**
6. **Railway will auto-detect and deploy**

### Step 3: Configure Environment Variables

In Railway dashboard, add these environment variables:

#### 🔐 Essential Variables
```bash
# Database (Supabase)
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.wavujxqosdbnmjcokdhl.supabase.co:5432/postgres

# Security
SECRET_KEY=your-production-secret-key-here
ENVIRONMENT=production

# Redis (Upstash - recommended)
REDIS_URL=redis://default:[PASSWORD]@[HOST]:[PORT]

# CORS (replace with your domain)
BACKEND_CORS_ORIGINS=["https://your-app.railway.app","https://yourdomain.com"]
```

#### 💳 Stripe Configuration
```bash
STRIPE_SECRET_KEY=sk_live_your_live_secret_key
STRIPE_PUBLISHABLE_KEY=pk_live_your_live_publishable_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
STRIPE_PRICE_STARTER=price_starter_monthly
STRIPE_PRICE_PRO=price_pro_monthly
STRIPE_PRICE_ENTERPRISE=price_enterprise_monthly
```

#### 🤖 AI Services
```bash
OPENAI_API_KEY=sk-your_openai_api_key_here
ANTHROPIC_API_KEY=sk-ant-your_anthropic_api_key_here
DEFAULT_AI_PROVIDER=openai
```

#### 📱 Telegram Configuration
```bash
TELEGRAM_API_ID=your_telegram_api_id
TELEGRAM_API_HASH=your_telegram_api_hash
```

#### 📞 WhatsApp Configuration (Twilio)
```bash
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
TWILIO_WHATSAPP_NUMBER=+14155238886
```

#### 📧 Email Configuration
```bash
SMTP_TLS=True
SMTP_PORT=587
SMTP_HOST=smtp.gmail.com
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
EMAILS_FROM_EMAIL=noreply@yourapp.com
EMAILS_FROM_NAME=AI Agent Service
```

#### 📊 Monitoring
```bash
SENTRY_DSN=your_sentry_dsn_here
```

### Step 4: Database Setup

1. **Run migrations:**
   ```bash
   # In Railway console or locally
   cd backend
   alembic upgrade head
   ```

2. **Verify Supabase connection:**
   - Test the connection in your app
   - Check Railway logs for any database errors

### Step 5: Configure External Services

#### Stripe Setup
1. **Create Stripe account** at [stripe.com](https://stripe.com)
2. **Create products and prices:**
   - Starter: $15/month
   - Pro: $49/month
   - Enterprise: $199/month
3. **Set up webhook:**
   - URL: `https://your-app.railway.app/api/v1/webhooks/stripe`
   - Events: `customer.subscription.*`, `invoice.payment_*`

#### Telegram Setup
1. **Create bot with @BotFather:**
   - Message [@BotFather](https://t.me/BotFather)
   - Use `/newbot` command
   - Get your bot token
2. **Get API credentials:**
   - Go to [my.telegram.org](https://my.telegram.org)
   - Create application
   - Get API ID and Hash

#### WhatsApp Setup (Twilio)
1. **Create Twilio account** at [twilio.com](https://twilio.com)
2. **Enable WhatsApp Sandbox**
3. **Get credentials and phone number**

## 🎯 Telegram Premium Chatbot Feature

### How It Works

1. **User Journey:**
   ```
   User creates bot → Pastes token → Configures AI → Enables Premium Chatbot → Bot responds automatically
   ```

2. **Technical Flow:**
   ```
   Token Validation → Bot Setup → Webhook Configuration → Premium Chatbot Activation → Message Processing
   ```

### API Endpoints for Premium Chatbot

- `POST /api/v1/bots/validate-telegram-token` - Validate bot token
- `GET /api/v1/bots/{bot_id}/telegram-info` - Get bot information
- `POST /api/v1/bots/{bot_id}/setup-premium-chatbot` - Setup Premium Chatbot
- `POST /api/v1/webhooks/telegram/{bot_id}` - Handle incoming messages

### Frontend Integration

Your dashboard should include:

1. **Bot Token Input:**
   ```javascript
   // Validate token before saving
   const validateToken = async (token) => {
     const response = await fetch('/api/v1/bots/validate-telegram-token', {
       method: 'POST',
       headers: { 'Content-Type': 'application/json' },
       body: JSON.stringify({ bot_token: token })
     });
     return response.json();
   };
   ```

2. **Premium Chatbot Setup:**
   ```javascript
   // Setup Premium Chatbot
   const setupPremiumChatbot = async (botId, webhookUrl) => {
     const response = await fetch(`/api/v1/bots/${botId}/setup-premium-chatbot`, {
       method: 'POST',
       headers: { 'Content-Type': 'application/json' },
       body: JSON.stringify({ webhook_url: webhookUrl })
     });
     return response.json();
   };
   ```

## 🔧 Railway-Specific Configuration

### Automatic Deployments

Railway will automatically deploy when you push to your main branch:

```bash
git add .
git commit -m "Update bot configuration"
git push origin main
# Railway automatically deploys
```

### Custom Domain

1. **In Railway dashboard:**
   - Go to your project
   - Click "Settings"
   - Add custom domain
   - Update CORS origins

2. **Update environment variables:**
   ```bash
   BACKEND_CORS_ORIGINS=["https://yourdomain.com","https://www.yourdomain.com"]
   ```

### Scaling

Railway automatically handles:
- **Horizontal scaling** based on traffic
- **Load balancing** across instances
- **Health checks** and auto-restart
- **Resource monitoring**

## 📊 Monitoring & Logs

### Railway Logs
- View logs in Railway dashboard
- Real-time log streaming
- Error tracking and debugging

### Health Checks
- Endpoint: `/health`
- Railway monitors automatically
- Auto-restart on failures

### Performance Monitoring
- Built-in metrics in Railway dashboard
- Response time monitoring
- Resource usage tracking

## 🚀 Post-Deployment Checklist

### ✅ Essential Checks
- [ ] Database migrations completed
- [ ] Environment variables configured
- [ ] Health check endpoint responding
- [ ] API documentation accessible at `/docs`
- [ ] Stripe webhooks configured and tested
- [ ] Telegram bot token validation working
- [ ] WhatsApp integration functional
- [ ] AI services responding correctly

### ✅ Premium Chatbot Testing
- [ ] Bot token validation endpoint working
- [ ] Bot setup endpoint functional
- [ ] Webhook receiving messages
- [ ] AI responses being generated
- [ ] Messages being sent back to users
- [ ] Premium Chatbot feature working in Telegram Business

### ✅ Business Features
- [ ] User registration and authentication
- [ ] Subscription management
- [ ] Payment processing
- [ ] Usage tracking and quotas
- [ ] Bot creation and management
- [ ] Analytics and reporting

## 🎯 Revenue Model Implementation

Your service is configured with:

- **Free Trial:** 7 days, 100 messages, 1 bot
- **Starter:** $15/month, 1,000 messages, 1 bot
- **Pro:** $49/month, 10,000 messages, 5 bots
- **Enterprise:** $199/month, 100,000 messages, unlimited bots

## 🔒 Security Considerations

- ✅ JWT authentication implemented
- ✅ Rate limiting configured
- ✅ CORS properly set up
- ✅ Input validation and sanitization
- ✅ Webhook signature verification
- ✅ Environment-based configuration
- ✅ Secure database connections

## 📞 Support & Troubleshooting

### Common Issues

1. **Database Connection Errors:**
   - Check DATABASE_URL format
   - Verify Supabase credentials
   - Check network connectivity

2. **Bot Token Validation Fails:**
   - Verify token format
   - Check bot permissions
   - Ensure bot is not already in use

3. **Webhook Not Receiving Messages:**
   - Check webhook URL configuration
   - Verify SSL certificate
   - Check Railway logs for errors

### Getting Help

- Check Railway logs first
- Verify environment variables
- Test API endpoints with `/docs`
- Check external service status
- Review error messages in logs

## 🎉 Launch Your SaaS!

Once deployed and tested:

1. **Share your Railway URL** with users
2. **Create marketing materials** highlighting Premium Chatbot feature
3. **Set up customer support** channels
4. **Monitor usage and performance**
5. **Scale as needed** with Railway's auto-scaling

Your AI Agent Service with Telegram Premium Chatbot support is now live on Railway! 🚀💰
