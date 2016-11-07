gcc hilos.c -o hilos -lpthread
echo > completeHilos.out
for (( N=8; N<1025; N+=N)); do	
	echo "--------------------" >> completeHilos.out
	echo Matriz $N >> completeHilos.out
	for (( H=1; H<17; H+=H)); do		
		echo >> completeHilos.out 
		echo "-" Num. Hilos $H >> completeHilos.out 
		for(( R=1; R<11; R++)); do
			echo >> completeHilos.out 
			echo "   - Repeticion " $R >> completeHilos.out 
			time(./hilos $H $N) &>> completeHilos.out
		done
	done	
done
gcc averageTimeHilos.c -o averageTimeHilos 
./averageTimeHilos > averageTimeHilos.out  
rm averageTimeHilos 
rm hilos 