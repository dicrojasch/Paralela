
gcc secuencial.c -o secuencial
echo > completeSecuencial.out
for (( N=8; N<1025; N+=N)); do	
	echo "--------------------" >> completeSecuencial.out
	echo Matriz $N >> completeSecuencial.out
	echo >> completeSecuencial.out			
	for(( R=1; R<11; R++)); do
		echo >> completeSecuencial.out
		echo "   - Repeticion " $R >> completeSecuencial.out
		time(./secuencial $N) &>> completeSecuencial.out
	done	

done
gcc averageTimeSec.c -o averageTimeSec
./averageTimeSec > averageTimeSec.out
rm averageTimeSec
rm secuencial