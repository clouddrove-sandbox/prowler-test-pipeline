CONSOLIDATED_REPORT=/home/runner/work/prowler/prowler/output/prowler-fullorgresults-temp.csv
CONSOLIDATED_REPORT_FILTERED=/home/runner/work/prowler/prowler/output/prowler-fullorgresults-accessdeniedfiltered.csv
# S3_BUCKET=$2

cat /home/runner/work/prowler/prowler/output/prowler-*.csv | sort | uniq > /home/runner/work/prowler/prowler/output/prowler-fullorgresults-raw.csv

awk '{a[NR]=$0} END {print a[NR]; for (i=1;i<NR;i++) print a[i]}' /home/runner/work/prowler/prowler/output/prowler-fullorgresults-raw.csv > output/PROCESS.csv

cat /home/runner/work/prowler/prowler/output/PROCESS.csv >> /home/runner/work/prowler/prowler/output/prowler-fullorgresults-temp.csv

rm -f /home/runner/work/prowler/prowler/output/PROCESS.csv

rm -rf /home/runner/work/prowler/prowler/output/prowler-fullorgresults-raw.csv

cat $CONSOLIDATED_REPORT | grep -v -i 'Access Denied getting bucket\|Access Denied Trying to Get\|InvalidToken' > $CONSOLIDATED_REPORT_FILTERED

python3 /home/runner/work/prowler/prowler/generateVisualizations.py

OUTPUT_SUFFIX=$(date +%F-%H-%M)

zip -r prowler_output-$OUTPUT_SUFFIX.zip output/*.csv output/*.txt output/*.json output/*.html output/ResultsVisualizations-*/*.*

# echo "------- Uploading zip file to S3 bucket ------------------------"
# aws s3 cp prowler_output-$OUTPUT_SUFFIX.zip s3://$S3_BUCKET