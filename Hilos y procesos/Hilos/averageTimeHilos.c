#include <stdio.h>  
#include <string.h> 
#include <stdlib.h> 

int main(){

    char c[1000];
    FILE *fptr;

    if ((fptr = fopen("completeHilos.out", "r")) == NULL)
    {
        printf("Error! opening file");
        // Program exits if file pointer returns NULL.
        return 1;         
    }
    int j, k;
    double sec, counter = 0, min;
    int start = 0, noNextLine = 0;

    // reads text until newline 
    while (1) {
    	if ( noNextLine == 0 ){
    		if (fgets(c,1000,fptr) == NULL){
    			break;
    		}
    	}else noNextLine = 0;        
        if( c[0] == 'M' ){        	
        	printf("%s", c);
        	c[0] = ' ';
        }else if( c[7] == 'H' ){
        	
        	printf("%s", c);
        	start = counter = 0;
        	c[7]  = ' ';
        	while (1) {      

        		if ( (fgets(c,1000,fptr) == NULL) || (c[0] == 'M' || (c[7] == 'H')) ){
					printf("      %f\n", counter / start );					
					noNextLine = 1;
					break;
				}else if( c[0] == 'r' ){
					start++;
					for(j = 0; j < 20; j++ ){
						if( c[j] == 'm'){				
							k = j-1;
							while (k > 0 && ( c[k] != '	' ))
								k--;        			
							// El minuto esta entre >= k y j <
							char temp_char[j-k];  
							strncpy ( temp_char, c+k+1, j-k-1);
							min = atof(temp_char);
							min *= 60;
							counter += min;
						}
						if( c[j] == 's' ){
						 	k = j-1;
							while (k > 0 && ( c[k] != 'm' ))        			
								k--;									
							// El segundo esta entre >= k y j <
							char temp_char[j-k];  
							strncpy ( temp_char, c+k+1, j-k-1);
							sec = atof(temp_char);
							counter += sec;
						}								
					}
				}				
        	}



        	        	        
        }



    }
    printf("\n" );
    

    
    fclose(fptr);
  
	return 0;
}