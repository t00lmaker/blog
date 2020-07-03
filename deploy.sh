#!/bin/bash

mix -v

if [ $? -eq 0 ]; then
  echo " mix ok"
  
  mix deps.get --only prod

  if [ $? -eq 0 ]; then
    echo " Dependencies installed "   
  else
    echo " Error! dependencies not installed "
    exit 0
  fi 

  export SECRET_KEY_BASE=$(mix phx.gen.secret)
  export DATABASE_URL=ecto://USER:PASS@HOST/database
  
  export MIX_ENV=prod
  export MIX_PORT=8080

  mix compile

  npm -v 

  if [ $? -ne 0 ]; then 
    echo "npm not found" 
    npm install -g npm
  fi
    
  npm run deploy --prefix ./assets
  
  mix phx.digest

  mix phx.server
  
  exit 0
else
  echo " mix not found"
  exit 1
fi  

