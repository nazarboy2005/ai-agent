#!/bin/bash

# AI Agent Service Setup Script
# This script sets up the development environment for the AI Agent Service

set -e

echo "🚀 Setting up AI Agent Service..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_status "Docker and Docker Compose are installed ✓"

# Create environment files if they don't exist
if [ ! -f backend/.env ]; then
    print_status "Creating backend environment file..."
    cp backend/env.example backend/.env
    print_warning "Please update backend/.env with your actual configuration values"
fi

if [ ! -f frontend/.env.local ]; then
    print_status "Creating frontend environment file..."
    cat > frontend/.env.local << EOF
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key_here
EOF
    print_warning "Please update frontend/.env.local with your actual configuration values"
fi

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p infrastructure/prometheus
mkdir -p infrastructure/grafana/dashboards
mkdir -p infrastructure/grafana/datasources
mkdir -p logs

# Create Prometheus configuration
print_status "Creating Prometheus configuration..."
cat > infrastructure/prometheus/prometheus.yml << EOF
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'ai-agent-backend'
    static_configs:
      - targets: ['backend:8000']
    metrics_path: '/metrics'
    scrape_interval: 30s

  - job_name: 'ai-agent-frontend'
    static_configs:
      - targets: ['frontend:3000']
    scrape_interval: 30s
EOF

# Create Grafana datasource configuration
print_status "Creating Grafana datasource configuration..."
cat > infrastructure/grafana/datasources/prometheus.yml << EOF
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF

# Create Grafana dashboard configuration
print_status "Creating Grafana dashboard configuration..."
cat > infrastructure/grafana/dashboards/dashboard.yml << EOF
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /etc/grafana/provisioning/dashboards
EOF

# Build and start services
print_status "Building and starting services with Docker Compose..."
docker-compose build

print_status "Starting services (using Supabase and Upstash cloud services)..."
docker-compose up -d

print_status "Running database migrations..."
docker-compose exec backend alembic upgrade head

print_success "Setup completed successfully! 🎉"

echo ""
echo "📋 Next Steps:"
echo "1. Update your environment files with actual API keys and configuration"
echo "2. Access the application:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend API: http://localhost:8000"
echo "   - API Documentation: http://localhost:8000/docs"
echo "   - Grafana: http://localhost:3001 (admin/admin)"
echo "   - Prometheus: http://localhost:9090"
echo ""
echo "3. Create your first bot:"
echo "   - Register an account at http://localhost:3000"
echo "   - Get a Telegram bot token from @BotFather"
echo "   - Create your first bot in the dashboard"
echo ""
echo "🔧 Useful Commands:"
echo "   - View logs: docker-compose logs -f [service_name]"
echo "   - Stop services: docker-compose down"
echo "   - Restart services: docker-compose restart"
echo "   - Update services: docker-compose pull && docker-compose up -d"
echo ""
echo "📚 Documentation:"
echo "   - README.md for detailed setup instructions"
echo "   - API docs at http://localhost:8000/docs"
echo ""

print_success "Happy coding! 🚀"
