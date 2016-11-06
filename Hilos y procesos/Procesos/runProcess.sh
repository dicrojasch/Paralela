for (( N=8; N<100; N+=N)); do
	for (( P=1; P<5; P++)); do
		volumes= "$(ls)"
		echo "$volumes"
		#time ./procesos $P $N
	done	
done