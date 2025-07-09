nohup env DATABASE_HOST=localhost REDIS_HOST=localhost npm start --prefix  /home/vagrant/roxs-devops-project90/roxs-voting-app/worker > worker.log 2>&1 &
sleep 3
nohup env APP_PORT=3001 DATABASE_HOST=localhost  npm start --prefix /home/vagrant/roxs-devops-project90/roxs-voting-app/result > result.log 2>&1 &
sleep 3
nohup env DATABASE_HOST=localhost /home/vagrant/roxs-devops-project90/roxs-voting-app/vote/venv/bin/python /home/vagrant/roxs-devops-project90/roxs-voting-app/vote/app.py > vote.log 2>&1 &
sleep 3
