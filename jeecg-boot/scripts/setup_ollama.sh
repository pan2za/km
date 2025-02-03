#!/bin/sh

# Pull default models
echo "Pulling embedding models..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "nomic-embed-text"
}'
# Pull default models
echo "Pulling embedding models with name bge-m3..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "bge-m3"
}'
# Pull default models
echo "Pulling embedding models with name bge-large..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "bge-large"
}'
# Pull default models
echo "Pulling embedding models with name bge-large-zh..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "quentinz/bge-large-zh-v1.5"
}'
echo "Pulling mistral model..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "mistral"
}'
echo "Pulling 768 embed model..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "mofanke/dmeta-embedding-zh"
}'

echo "Pulling realbig deepseek model..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "deepseek-coder-v2:16b-lite-instruct-q5_K_M"
}'
echo "Pulling ${MODEL} model..."
curl -X POST ${OLLAMA_BASE_URL}/api/pull -d '{
  "name": "'${MODEL}'"
}'
