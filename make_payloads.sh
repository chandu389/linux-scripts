getPayload(){
  cd /Users/vgolugur/Downloads/Misc/test_data/$1
  filename=$(cat actual/after/$(ls -1 ./actual/after | grep 'e2e_show_running-config_rmno_network-service_deployment.*') | head -1 | rev | cut -d" " -f 1 | rev | tr -d '\r')

  echo $filename
  mkdir -p ../payloads/$filename
  A="$(cut -d'-' -f3 <<<"$1")"
  B=$(($A+1))
  delete_dir=2-1-$B

  cat input/$(ls -1 ./input/ | grep '.*.json') | python -m json.tool > payload.json

  cat actual/after/$(ls -1 ./actual/after | grep 'e2e_show_running-config_rmno_network-service_deployment.*') > nso_deployment

  cat actual/No_1_notification.txt | tail -2 | head -1 | tr \' \" | python -m json.tool > create_notif
  cat actual/No_1_notification.txt | tail -1 | tr \' \" | python -m json.tool >> create_notif

  echo "moving files create $filename"
  mv payload.json ../payloads/$filename/
  mv create_notif ../payloads/$filename/
  mv nso_deployment ../payloads/$filename/

  cd /Users/vgolugur/Downloads/Misc/test_data/$delete_dir
  cat actual/No_1_notification.txt | tail -2 | head -1 | tr \' \" | python -m json.tool > delete_notif
  cat actual/No_1_notification.txt | tail -1 | tr \' \" | python -m json.tool >> delete_notif
  echo "moving files delete $filename"
  mv delete_notif ../payloads/$filename/
}

for arg in "$@"; do
  getPayload "$arg"
done

cd /Users/vgolugur/Downloads/Misc/test_data
tar -cf payloads.tar payloads/
