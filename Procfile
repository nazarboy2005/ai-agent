web: cd backend && uvicorn app.main:app --host 0.0.0.0 --port $PORT
worker: cd backend && celery -A app.core.celery worker --loglevel=info
beat: cd backend && celery -A app.core.celery beat --loglevel=info
