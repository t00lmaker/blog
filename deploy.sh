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

  mix compile \
    && npm run deploy --prefix ./assets \
    && mix phx.digest
	
  exit 0
else
  echo " mix not found"
  exit 1
fi  

