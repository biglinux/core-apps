#!/bin/bash

# Executa otimizacoes do prelink
apt-get dist-upgrade --yes --force-yes --no-install-recommends
prelink -amR
