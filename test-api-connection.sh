#!/bin/bash

# Test script to verify API connection without running the full app
echo "🧪 Testing Moonshot API Connection"
echo "=================================="

# Check if API key is set
if [ -z "$MOONSHOT_API_KEY" ]; then
    echo "❌ MOONSHOT_API_KEY is not set"
    echo ""
    echo "To test the API connection, please:"
    echo "1. Get your API key from https://console.moonshot.ai/"
    echo "2. Set it temporarily: export MOONSHOT_API_KEY=\"sk-your-key\""
    echo "3. Run this script again"
    exit 1
fi

echo "✅ API key is set (${#MOONSHOT_API_KEY} characters)"
echo ""

# Test API connection
echo "🔄 Testing API connection..."
response=$(curl -s -w "\nHTTP_CODE:%{http_code}" \
    -H "Authorization: Bearer $MOONSHOT_API_KEY" \
    -H "Content-Type: application/json" \
    https://api.moonshot.ai/v1/users/me/balance)

# Extract HTTP code
http_code=$(echo "$response" | grep "HTTP_CODE:" | cut -d: -f2)
json_response=$(echo "$response" | sed '/HTTP_CODE:/d')

echo "HTTP Status: $http_code"

if [ "$http_code" = "200" ]; then
    echo "✅ API connection successful!"
    echo ""
    echo "Response:"
    echo "$json_response" | python3 -m json.tool 2>/dev/null || echo "$json_response"
    echo ""
    echo "🎉 Your API key is working! Ready to test the app."
elif [ "$http_code" = "401" ]; then
    echo "❌ Authentication failed"
    echo "Please check your API key is correct"
elif [ "$http_code" = "000" ]; then
    echo "❌ Network error - could not connect to API"
    echo "Please check your internet connection"
else
    echo "❌ API returned HTTP $http_code"
    echo "Response: $json_response"
fi