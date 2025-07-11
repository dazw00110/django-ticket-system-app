#!/bin/bash

echo "=== Uruchamianie kontenera PostgreSQL ==="
docker start ticket_system || docker run --name ticket_system -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=ticket_system -p 5432:5432 -d postgres:15

echo "=== Czekanie na bazę ==="
sleep 5

echo "=== Tworzenie i aktywacja virtualenv ==="
[ ! -d "venv" ] && python -m venv venv
source venv/Scripts/activate  # Windows/Git Bash
# source venv/bin/activate    # Linux/Mac

echo "=== Instalowanie zależności ==="
pip install -r requirements.txt

echo "=== Migracje ==="
python manage.py migrate

echo "=== Start Django ==="
# Odpalamy serwer w tle
python manage.py runserver &

echo "=== Serwer działa! Otwórz przeglądarkę i wpisz: http://127.0.0.1:8000 ==="

# gdy przerwiesz serwer, skrypt dojdzie tu i zapauzuje okno
read -p 'Naciśnij ENTER, aby zamknąć...'
