#!/bin/bash

export MIX_ENV=prd

mix -v

if [ $? -eq 0 ]; then
  echo " mix ok"
  
  mix deps.get --only prod \
    && mix compile \
    && npm run deploy --prefix ./assets \
    && mix phx.digest
	    

  if [ $? -eq 0 ]; then
    echo " Dependencies installed "   
  else
    echo " Error! dependencies not installed "
    exit 0
  fi 

  mix phx.gen.secret

  if [ $? -eq 0 ]; then
      echo " key generate  $? " 
  fi

  exit 0
else
  echo " mix not found"
  exit 1
fi  

