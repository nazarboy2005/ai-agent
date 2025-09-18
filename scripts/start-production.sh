#!/bin/bash

# AI Agent Service - Production Startup Script
# This script helps you deploy the production-ready AI Agent Service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}[HEADER]${NC} $1"
}

# Banner
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    AI Agent Service                          ║"
echo "║                 Production Deployment                        ║"
echo "║                                                              ║"
echo "║  🚀 Telegram + WhatsApp AI Agent SaaS Platform              ║"
echo "║  💰 Revenue Model: 7-day trial → $15/$49/$199 tiers        ║"
echo "║  🔧 Tech Stack: FastAPI + Next.js + Supabase + Stripe      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_header "🎯 Production Deployment Options"

echo ""
echo "Choose your deployment method:"
echo "1) Railway (Recommended - Full Stack)"
echo "2) Vercel (Frontend) + Railway (Backend)"
echo "3) Docker (Self-hosted)"
echo "4) Manual Setup Guide"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        print_header "🚀 Deploying to Railway (Full Stack)"
        
        print_status "Railway is the easiest way to deploy your full-stack application"
        echo ""
        echo "Steps to deploy:"
        echo "1. Go to https://railway.app"
        echo "2. Sign up with GitHub"
        echo "3. Click 'New Project' → 'Deploy from GitHub repo'"
        echo "4. Select your AI Agent Service repository"
        echo "5. Railway will automatically detect and deploy both frontend and backend"
        echo ""
        echo "Required Environment Variables:"
        echo "DATABASE_URL=postgresql://postgres:[PASSWORD]@db.wavujxqosdbnmjcokdhl.supabase.co:5432/postgres"
        echo "SECRET_KEY=your-production-secret-key"
        echo "STRIPE_SECRET_KEY=sk_live_your_live_key"
        echo "OPENAI_API_KEY=sk-your_openai_key"
        echo "TELEGRAM_API_ID=your_api_id"
        echo "TELEGRAM_API_HASH=your_api_hash"
        echo "TWILIO_ACCOUNT_SID=your_account_sid"
        echo "TWILIO_AUTH_TOKEN=your_auth_token"
        echo ""
        print_success "Railway will handle the rest automatically!"
        ;;
        
    2)
        print_header "🎨 Deploying Frontend to Vercel + Backend to Railway"
        
        print_status "This approach gives you the best of both platforms"
        echo ""
        echo "Frontend (Vercel):"
        echo "1. Go to https://vercel.com"
        echo "2. Import your GitHub repository"
        echo "3. Set Root Directory to 'frontend'"
        echo "4. Add environment variables:"
        echo "   NEXT_PUBLIC_API_URL=https://your-backend-url.railway.app"
        echo "   NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_your_key"
        echo ""
        echo "Backend (Railway):"
        echo "1. Deploy backend to Railway (same as option 1)"
        echo "2. Use all the environment variables from option 1"
        echo ""
        print_success "Both platforms will auto-deploy on git push!"
        ;;
        
    3)
        print_header "🐳 Deploying with Docker"
        
        print_status "Setting up production Docker deployment..."
        
        # Check if Docker is installed
        if ! command -v docker &> /dev/null; then
            print_error "Docker is not installed. Please install Docker first."
            exit 1
        fi
        
        if ! command -v docker-compose &> /dev/null; then
            print_error "Docker Compose is not installed. Please install Docker Compose first."
            exit 1
        fi
        
        # Create production environment file
        if [ ! -f .env ]; then
            print_status "Creating production environment file..."
            cp env.production .env
            print_warning "Please update .env with your actual production values"
        fi
        
        # Build and start services
        print_status "Building and starting production services..."
        docker-compose -f docker-compose.prod.yml build
        docker-compose -f docker-compose.prod.yml up -d
        
        print_success "Production deployment started!"
        echo ""
        echo "Services running:"
        echo "- Frontend: http://localhost:3000"
        echo "- Backend: http://localhost:8000"
        echo "- API Docs: http://localhost:8000/docs"
        echo "- Grafana: http://localhost:3001 (admin/admin)"
        echo "- Prometheus: http://localhost:9090"
        ;;
        
    4)
        print_header "📖 Manual Setup Guide"
        
        echo ""
        echo "For detailed manual setup instructions, see:"
        echo "- DEPLOYMENT.md - Complete deployment guide"
        echo "- PRODUCTION_READY.md - Production readiness checklist"
        echo "- README.md - Project overview and setup"
        echo ""
        echo "Quick manual setup:"
        echo "1. Set up Supabase database"
        echo "2. Configure environment variables"
        echo "3. Run database migrations"
        echo "4. Deploy backend (FastAPI)"
        echo "5. Deploy frontend (Next.js)"
        echo "6. Configure external services (Stripe, Telegram, WhatsApp)"
        echo "7. Set up monitoring (Sentry, Prometheus)"
        ;;
        
    *)
        print_error "Invalid choice. Please run the script again and choose 1-4."
        exit 1
        ;;
esac

echo ""
print_header "🔧 Post-Deployment Configuration"

echo ""
echo "After deployment, you need to configure:"
echo ""
echo "1. 📊 Database Setup:"
echo "   - Run migrations: alembic upgrade head"
echo "   - Verify connection to Supabase"
echo ""
echo "2. 💳 Stripe Configuration:"
echo "   - Create products and prices in Stripe Dashboard"
echo "   - Set up webhook endpoint: https://yourdomain.com/api/v1/webhooks/stripe"
echo "   - Configure webhook events: customer.subscription.*, invoice.payment_*"
echo ""
echo "3. 🤖 Telegram Bot Setup:"
echo "   - Create bot with @BotFather"
echo "   - Get API credentials from my.telegram.org"
echo "   - Configure webhook URL"
echo ""
echo "4. 📱 WhatsApp Setup:"
echo "   - Create Twilio account"
echo "   - Enable WhatsApp Sandbox"
echo "   - Configure webhook URL"
echo ""
echo "5. 🔍 Monitoring Setup:"
echo "   - Configure Sentry DSN"
echo "   - Set up Prometheus/Grafana (if using Docker)"
echo "   - Test health check endpoints"
echo ""

print_header "🎯 Revenue Model Ready"

echo ""
echo "Your SaaS is configured with:"
echo "💰 Free Trial: 7 days, 100 messages, 1 bot"
echo "💰 Starter: $15/month, 1,000 messages, 1 bot"
echo "💰 Pro: $49/month, 10,000 messages, 5 bots"
echo "💰 Enterprise: $199/month, 100,000 messages, unlimited bots"
echo ""

print_header "🚀 Launch Checklist"

echo ""
echo "Before going live:"
echo "✅ Database migrations completed"
echo "✅ Environment variables configured"
echo "✅ Stripe webhooks tested"
echo "✅ Telegram bot responding"
echo "✅ WhatsApp integration working"
echo "✅ AI services responding"
echo "✅ Monitoring configured"
echo "✅ SSL certificates installed"
echo "✅ Domain configured"
echo "✅ Error tracking active"
echo ""

print_success "🎉 Your AI Agent Service is ready to launch!"
echo ""
echo "📚 Documentation:"
echo "- API Docs: https://yourdomain.com/docs"
echo "- Deployment Guide: DEPLOYMENT.md"
echo "- Production Guide: PRODUCTION_READY.md"
echo ""
echo "💡 Pro Tips:"
echo "- Start with a soft launch to test everything"
echo "- Monitor your first users closely"
echo "- Set up alerts for errors and performance issues"
echo "- Keep your API keys secure"
echo "- Regular backups of your database"
echo ""
echo "🚀 Happy launching your AI Agent SaaS business!"
