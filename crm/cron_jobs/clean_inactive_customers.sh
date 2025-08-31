#!/bin/bash

# Navigate to the Django project root (adjust path if needed)
PROJECT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
cd "$PROJECT_DIR" || exit 1

# Run Django shell command to delete inactive customers
DELETED_COUNT=$(python3 manage.py shell -c "
import datetime
from crm.models import Customer

cutoff_date = datetime.datetime.now() - datetime.timedelta(days=365)
qs = Customer.objects.filter(orders__isnull=True, created_at__lt=cutoff_date).distinct()
count = qs.count()
qs.delete()
print(count)
")

# Log result with timestamp
echo \"\$(date '+%Y-%m-%d %H:%M:%S') - Deleted customers: $DELETED_COUNT\" >> /tmp/customer_cleanup_log.txt
