
gcc procesos.c -o procesos
echo > completeProcess.out
for (( N=8; N<1025; N+=N)); do	
	echo "--------------------" >> completeProcess.out
	echo Matriz $N >> completeProcess.out
	for (( P=1; P<5; P+=P)); do	
		echo >> completeProcess.out
		echo "-" Num. Procesos $P >> completeProcess.out				
		for(( R=1; R<11; R++)); do
			echo >> completeProcess.out
			echo "   - Repeticion " $R >> completeProcess.out
			time(./procesos $P $N) &>> completeProcess.out
		done	
	done	
done
gcc averageTimeProcess.c -o averageTimeProcess
./averageTimeProcess > averageTimeProcess.out
rm averageTimeProcess
rm procesos