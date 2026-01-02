#!/bin/bash

echo "🚀 Starting Voting App Load Test Demo..."
echo "📊 Open these URLs to watch metrics:"
echo "   Grafana: http://localhost:30091 (admin/admin123)"
echo "   Prometheus: http://localhost:30090"
echo "   Jaeger: http://localhost:16686"
echo "   Kibana: http://localhost:30093"
echo ""

# Función para votar
vote_round() {
    local round=$1
    local votes=$2
    echo "📈 Round $round: Generating $votes votes..."
    
    for i in $(seq 1 $votes); do
        # Random vote
        if [ $((RANDOM % 2)) -eq 0 ]; then
            curl -s http://localhost:30080/vote/cats > /dev/null &
        else
            curl -s http://localhost:30080/vote/dogs > /dev/null &
        fi
        
        # Check results occasionally
        if [ $((i % 10)) -eq 0 ]; then
            curl -s http://localhost:30081/ > /dev/null &
        fi
    done
    wait
}

# Demo scenario
echo "🎭 Demo Scenario:"
echo "1. Normal load (30 votes)"
vote_round 1 30
sleep 10

echo "2. High load (100 votes)"
vote_round 2 100
sleep 15

echo "3. Spike load (200 votes)"
vote_round 3 200
sleep 10

echo "4. Cool down (20 votes)"
vote_round 4 20

echo "✅ Load test completed!"
echo ""
echo "📊 Check your dashboards for:"
echo "   • Vote rate spikes"
echo "   • Response time changes"
echo "   • Queue length variations"
echo "   • Traces in Jaeger"
echo "   • Logs in Kibana"