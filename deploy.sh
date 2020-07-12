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
  export PORT=8080

  mix compile

  npm -v 

  if [ $? -ne 0 ]; then 
    echo "npm not found" 
    npm install -g npm
  fi

  npm install --prefix ./assets
    
  npm run deploy --prefix ./assets
  
  mix phx.digest

  mix distillery.init

  mix distillery.release

  echo "start server port: $PORT" 
  
  nohup _build/prod/rel/blog/bin/blog foreground &
  
  exit 0   
else
  echo " mix not found"
  exit 1
fi  

