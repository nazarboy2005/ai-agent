# 🚀 Supabase Setup Guide - AI Agent Service

## Overview

Your AI Agent Service is configured to use **Supabase only** for the database. This guide will help you set up Supabase and configure your application.

## 🎯 Why Supabase?

- ✅ **Managed PostgreSQL** - No local database setup needed
- ✅ **Real-time subscriptions** - Perfect for chat applications
- ✅ **Built-in authentication** - Optional for future features
- ✅ **Auto-scaling** - Handles traffic spikes automatically
- ✅ **Backup & recovery** - Enterprise-grade reliability
- ✅ **Global CDN** - Fast worldwide access

## 🔧 Supabase Setup

### Step 1: Create Supabase Project

1. **Go to [supabase.com](https://supabase.com)**
2. **Sign up** with GitHub or email
3. **Click "New Project"**
4. **Choose organization** (or create one)
5. **Enter project details:**
   - Name: `ai-agent-service`
   - Database Password: `[Generate strong password]`
   - Region: Choose closest to your users
6. **Click "Create new project"**

### Step 2: Get Connection Details

Once your project is created, go to **Settings → Database**:

#### Option 1: Direct Connection (Recommended)
```bash
# Connection string format
postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

# Example
postgresql://postgres:yourpassword123@db.wavujxqosdbnmjcokdhl.supabase.co:5432/postgres
```

#### Option 2: Transaction Pooler (For serverless)
```bash
# Connection string format
postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-1-eu-north-1.pooler.supabase.com:6543/postgres

# Example
postgresql://postgres.wavujxqosdbnmjcokdhl:yourpassword123@aws-1-eu-north-1.pooler.supabase.com:6543/postgres
```

#### Option 3: Session Pooler (IPv4 compatible)
```bash
# Connection string format
postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-1-eu-north-1.pooler.supabase.com:5432/postgres

# Example
postgresql://postgres.wavujxqosdbnmjcokdhl:yourpassword123@aws-1-eu-north-1.pooler.supabase.com:5432/postgres
```

### Step 3: Configure Environment Variables

Update your `.env` file with Supabase credentials:

```bash
# Database - Supabase Only
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

# Individual parameters (for direct connection)
POSTGRES_SERVER=db.[PROJECT-REF].supabase.co
POSTGRES_USER=postgres
POSTGRES_PASSWORD=[YOUR-PASSWORD]
POSTGRES_DB=postgres
POSTGRES_PORT=5432
```

## 🗄️ Database Setup

### Step 1: Run Migrations

```bash
# Navigate to backend directory
cd backend

# Install dependencies
pip install -r requirements.txt

# Run migrations
alembic upgrade head
```

### Step 2: Verify Tables

Go to **Supabase Dashboard → Table Editor** to see your tables:
- ✅ `users` - User accounts and profiles
- ✅ `bots` - Bot configurations
- ✅ `messages` - Message history
- ✅ `subscriptions` - Subscription management

## 🔐 Security Configuration

### Step 1: Row Level Security (RLS)

Enable RLS on your tables:

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE bots ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Create policies (example for users table)
CREATE POLICY "Users can view own data" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own data" ON users
  FOR UPDATE USING (auth.uid() = id);
```

### Step 2: API Keys (Optional)

If you want to use Supabase's built-in features:

1. **Go to Settings → API**
2. **Copy your keys:**
   - `anon` key (public)
   - `service_role` key (private)

## 🚀 Deployment

### Railway Deployment

1. **Set environment variables in Railway:**
   ```bash
   DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   ```

2. **Deploy to Railway:**
   - Railway will automatically connect to Supabase
   - No local database setup needed

### Docker Deployment

1. **Update docker-compose.yml:**
   ```yaml
   environment:
     - DATABASE_URL=${DATABASE_URL}
   ```

2. **Set environment variables:**
   ```bash
   export DATABASE_URL="postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"
   ```

3. **Start services:**
   ```bash
   docker-compose up -d
   ```

## 📊 Monitoring & Analytics

### Supabase Dashboard

Monitor your database in real-time:
- **Table Editor** - View and edit data
- **SQL Editor** - Run custom queries
- **Logs** - Database activity logs
- **API** - REST API documentation

### Performance Monitoring

- **Connection pooling** - Automatic connection management
- **Query performance** - Built-in query analysis
- **Resource usage** - CPU, memory, storage monitoring
- **Backup status** - Automated backup monitoring

## 🔧 Troubleshooting

### Common Issues

1. **Connection Refused:**
   - Check your DATABASE_URL format
   - Verify password is correct
   - Ensure project is not paused

2. **Migration Errors:**
   - Check database permissions
   - Verify connection string
   - Run migrations one by one

3. **Performance Issues:**
   - Check connection pooling settings
   - Monitor query performance
   - Consider upgrading plan

### Connection Testing

Test your connection:

```python
import psycopg2

try:
    connection = psycopg2.connect(
        "postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"
    )
    print("✅ Connection successful!")
    connection.close()
except Exception as e:
    print(f"❌ Connection failed: {e}")
```

## 💡 Pro Tips

### Performance Optimization

1. **Use Connection Pooling:**
   - Transaction pooler for serverless
   - Session pooler for persistent connections

2. **Index Optimization:**
   - Add indexes on frequently queried columns
   - Monitor query performance

3. **Query Optimization:**
   - Use prepared statements
   - Limit result sets
   - Use proper WHERE clauses

### Security Best Practices

1. **Environment Variables:**
   - Never commit database URLs
   - Use different credentials for dev/prod
   - Rotate passwords regularly

2. **Access Control:**
   - Enable RLS on all tables
   - Create appropriate policies
   - Limit API access

3. **Monitoring:**
   - Set up alerts for unusual activity
   - Monitor connection counts
   - Track query performance

## 🎯 Next Steps

1. **✅ Supabase project created**
2. **✅ Database URL configured**
3. **✅ Migrations run**
4. **✅ Application deployed**
5. **✅ Monitoring configured**

Your AI Agent Service is now running on Supabase! 🚀

## 📞 Support

- **Supabase Docs:** [supabase.com/docs](https://supabase.com/docs)
- **Community:** [github.com/supabase/supabase](https://github.com/supabase/supabase)
- **Discord:** [discord.supabase.com](https://discord.supabase.com)
