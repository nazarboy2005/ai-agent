# AI Agent Service - Production Deployment Guide

This guide covers deploying the AI Agent Service to production using various platforms.

## 🚀 Quick Deploy Options

### 1. Railway (Recommended for Full-Stack)

Railway is perfect for deploying both frontend and backend with database support.

**Steps:**
1. Connect your GitHub repository to Railway
2. Set environment variables in Railway dashboard
3. Deploy automatically

**Environment Variables:**
```bash
# Database (Supabase)
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.wavujxqosdbnmjcokdhl.supabase.co:5432/postgres

# Security
SECRET_KEY=your-production-secret-key
ENVIRONMENT=production

# Redis (Upstash)
REDIS_URL=redis://default:[PASSWORD]@[HOST]:[PORT]

# Stripe
STRIPE_SECRET_KEY=sk_live_your_live_key
STRIPE_PUBLISHABLE_KEY=pk_live_your_live_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# AI Services
OPENAI_API_KEY=sk-your_openai_key
ANTHROPIC_API_KEY=sk-ant-your_anthropic_key

# Telegram
TELEGRAM_API_ID=your_api_id
TELEGRAM_API_HASH=your_api_hash

# WhatsApp
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
```

### 2. Vercel (Frontend) + Railway (Backend)

**Frontend (Vercel):**
1. Connect GitHub repository to Vercel
2. Set build command: `cd frontend && npm run build`
3. Set output directory: `frontend/.next`
4. Add environment variables

**Backend (Railway):**
1. Deploy backend to Railway
2. Use the same environment variables as above

### 3. Docker Deployment

**Using Docker Compose:**
```bash
# Copy production environment file
cp env.production .env

# Update .env with your production values
nano .env

# Deploy with Docker Compose
docker-compose -f docker-compose.prod.yml up -d
```

## 🔧 Platform-Specific Configurations

### Supabase Database Setup

1. **Create Supabase Project:**
   - Go to [supabase.com](https://supabase.com)
   - Create new project
   - Get connection details

2. **Run Database Migrations:**
   ```bash
   # Install dependencies
   pip install -r backend/requirements.txt
   
   # Run migrations
   cd backend
   alembic upgrade head
   ```

3. **Connection Options:**
   - **Direct Connection:** Best for persistent connections
   - **Transaction Pooler:** Best for serverless functions
   - **Session Pooler:** IPv4 compatible alternative

### Redis Setup (Upstash)

1. **Create Upstash Redis:**
   - Go to [upstash.com](https://upstash.com)
   - Create Redis database
   - Get connection URL

2. **Update Environment:**
   ```bash
   REDIS_URL=redis://default:[PASSWORD]@[HOST]:[PORT]
   ```

### Stripe Setup

1. **Create Stripe Account:**
   - Go to [stripe.com](https://stripe.com)
   - Create account and get API keys
   - Create products and prices

2. **Configure Webhooks:**
   - Add webhook endpoint: `https://yourdomain.com/api/v1/webhooks/stripe`
   - Select events: `customer.subscription.*`, `invoice.payment_*`

### Telegram Bot Setup

1. **Create Bot:**
   - Message [@BotFather](https://t.me/BotFather)
   - Create new bot with `/newbot`
   - Get bot token

2. **Get API Credentials:**
   - Go to [my.telegram.org](https://my.telegram.org)
   - Create application
   - Get API ID and Hash

### WhatsApp Setup (Twilio)

1. **Create Twilio Account:**
   - Go to [twilio.com](https://twilio.com)
   - Create account and get credentials
   - Enable WhatsApp Sandbox

2. **Configure WhatsApp:**
   - Get WhatsApp number
   - Set up webhook URL

## 📊 Monitoring & Observability

### Sentry Setup

1. **Create Sentry Project:**
   - Go to [sentry.io](https://sentry.io)
   - Create new project
   - Get DSN

2. **Configure:**
   ```bash
   SENTRY_DSN=https://your-dsn@sentry.io/project-id
   ```

### Prometheus & Grafana

For self-hosted deployments:

```bash
# Start monitoring stack
docker-compose -f docker-compose.prod.yml up -d prometheus grafana

# Access Grafana at http://localhost:3001
# Default credentials: admin/admin
```

## 🔒 Security Checklist

### Environment Variables
- [ ] Use strong, unique SECRET_KEY
- [ ] Enable HTTPS in production
- [ ] Set secure CORS origins
- [ ] Use production Stripe keys
- [ ] Configure proper database permissions

### Application Security
- [ ] Enable rate limiting
- [ ] Set up proper authentication
- [ ] Configure webhook signatures
- [ ] Use environment-specific configurations
- [ ] Enable security headers

### Infrastructure Security
- [ ] Use managed databases
- [ ] Enable SSL/TLS
- [ ] Configure firewall rules
- [ ] Set up monitoring alerts
- [ ] Regular security updates

## 🚀 Deployment Commands

### Railway
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway link
railway up
```

### Vercel
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod
```

### Docker
```bash
# Build and deploy
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Update deployment
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

## 📈 Scaling Considerations

### Database
- Use connection pooling
- Monitor query performance
- Set up read replicas for heavy read workloads
- Implement proper indexing

### Caching
- Use Redis for session storage
- Cache frequently accessed data
- Implement cache invalidation strategies

### Background Tasks
- Use Celery for async processing
- Scale workers based on load
- Monitor task queues

### CDN
- Use CloudFlare or similar for static assets
- Enable gzip compression
- Set proper cache headers

## 🔍 Troubleshooting

### Common Issues

1. **Database Connection Errors:**
   - Check DATABASE_URL format
   - Verify network connectivity
   - Check firewall rules

2. **Redis Connection Issues:**
   - Verify REDIS_URL
   - Check Redis server status
   - Monitor memory usage

3. **Webhook Failures:**
   - Check webhook URLs
   - Verify signature validation
   - Monitor webhook logs

4. **Rate Limiting:**
   - Adjust rate limits in configuration
   - Monitor usage patterns
   - Implement proper backoff strategies

### Monitoring

- Check application logs
- Monitor database performance
- Track API response times
- Monitor error rates
- Watch resource usage

## 📞 Support

For deployment issues:
1. Check the logs first
2. Verify environment variables
3. Test database connectivity
4. Check external service status
5. Review security configurations

## 🎯 Production Checklist

- [ ] Database migrations completed
- [ ] Environment variables configured
- [ ] SSL certificates installed
- [ ] Monitoring configured
- [ ] Backup strategy implemented
- [ ] Error tracking enabled
- [ ] Performance monitoring active
- [ ] Security headers configured
- [ ] Rate limiting enabled
- [ ] Webhook endpoints tested
- [ ] Payment processing tested
- [ ] Bot integrations working
- [ ] AI services responding
- [ ] Documentation updated
