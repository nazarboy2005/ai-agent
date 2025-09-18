# AI Agent Service - Telegram + WhatsApp SaaS Platform

A comprehensive SaaS platform for creating and managing AI-powered chatbots across Telegram and WhatsApp platforms.

## Architecture Overview

- **Frontend**: Next.js React dashboard
- **Backend**: FastAPI async API with platform adapters
- **Adapters**: Telegram (Telethon), WhatsApp (Twilio/Infobip/Meta Cloud API)
- **AI Layer**: OpenAI/Anthropic with abstraction for local models
- **Database**: PostgreSQL with Redis caching
- **Storage**: S3 for media and file storage
- **Infrastructure**: Docker, Kubernetes/ECS, Prometheus/Grafana, Sentry
- **Billing**: Stripe with 7-day free trial

## Quick Start

### Development Setup

1. **Backend Setup**:
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

2. **Frontend Setup**:
```bash
cd frontend
npm install
npm run dev
```

3. **Database Setup**:
```bash
docker-compose up -d postgres redis
alembic upgrade head
```

### Production Deployment

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## Project Structure

```
├── backend/                 # FastAPI backend
│   ├── app/
│   │   ├── api/            # API routes
│   │   ├── core/           # Core configuration
│   │   ├── models/         # Database models
│   │   ├── schemas/        # Pydantic schemas
│   │   ├── services/       # Business logic
│   │   ├── adapters/       # Platform adapters
│   │   └── utils/          # Utilities
│   ├── alembic/            # Database migrations
│   └── tests/              # Backend tests
├── frontend/               # Next.js frontend
│   ├── components/         # React components
│   ├── pages/              # Next.js pages
│   ├── hooks/              # Custom hooks
│   ├── services/           # API services
│   └── styles/             # Styling
├── infrastructure/         # Infrastructure configs
│   ├── docker/             # Docker configurations
│   ├── k8s/                # Kubernetes manifests
│   └── terraform/          # Infrastructure as code
├── docs/                   # Documentation
└── scripts/                # Utility scripts
```

## Features

### MVP Features
- ✅ User registration with 7-day free trial
- ✅ Telegram bot integration via Bot API
- ✅ WhatsApp integration via BSP partners
- ✅ AI-powered conversation handling
- ✅ Bot behavior configuration via plain language
- ✅ Stripe subscription management
- ✅ Usage tracking and quotas

### Planned Features
- 📋 Template marketplace
- 📋 Advanced analytics dashboard
- 📋 Multi-language support
- 📋 Enterprise features
- 📋 Direct Meta Cloud API integration

## Subscription Tiers

- **Starter**: $15/month - 1,000 messages, 1 bot
- **Pro**: $49/month - 10,000 messages, 5 bots
- **Enterprise**: Custom pricing - Unlimited messages, unlimited bots

## Development Roadmap

- **Weeks 0-2**: Foundations (spec, infra, Stripe integration)
- **Weeks 2-5**: Telegram MVP
- **Weeks 5-8**: WhatsApp MVP via BSP
- **Weeks 8-12**: Polish, analytics, beta launch
- **Beyond**: Direct Cloud API, templates marketplace, enterprise features

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

Proprietary - All rights reserved
