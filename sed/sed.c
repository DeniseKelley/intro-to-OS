#include "types.h"
#include "stat.h"
#include "user.h"



char buf[512];

void sed(int fd, char *name, char *find, char * replace) {
  
  
  int i, n;
  int len_find = strlen(find);
  int j, counter, k;
  
  //flag
  int not_found=0;  

//reading from the buffer
  while ((n = read(fd, buf, sizeof(buf))) > 0) {  
    for (i = 0; i < n; i++) {

    
        //when the first matching letter is found
        if(buf[i]==find[1])
        {
            //set the counters
            j=i;
            counter = 1;
            //while matching continue increasing counters
            while(buf[j]==find[counter] ) 
            {        
                j++;
                counter++;
            }
            
            //when counter reaches the end of the search word
            //3 cases: 
                     //length of find == replace 
                     //length of find < replace
                     //length of find >  replace
            if (counter==len_find)
            {    
                //length of find == replace 
                if(len_find==strlen(replace))    
                {        
                    not_found=1;
                    j=i;
                    counter = 1;

                    
                    for(k=1; k<len_find; k++)
                    {
                        buf[j]=replace[counter];
                                       
                        j++;
                        counter++;
                    }
                }

                //length of find < replace
                else if(len_find<strlen(replace))
                {
                    not_found=1;
                    j=i;
                    counter = 1;

                    // find the difference between two words and icrease the size of the string
                    int difference = strlen(replace)-len_find;
                    n=n+difference;

                    for(k=n; k>=j; k--)
                    {
                        //move elements in the buffer to the right to make new space
                        buf[k]=buf[k-difference];
                    }
                    for(k=1; k<strlen(replace);k++)
                    {
                        //replace
                        buf[j]=replace[k];
                        j++;
                    }                          
                }
                //length of find >  replace
                else if(len_find>strlen(replace))
                {
                    not_found=1;
                    j=i;
                    counter = 1;
                    
                    //find the difference between two words
                    int difference = len_find-strlen(replace);

                    for(k=j; k<n-difference; k++)
                    {
                        //
                        buf[k+strlen(replace)-1]=buf[k+difference+strlen(replace)-1];
                    }
                   
                    for(k=1; k<strlen(replace);k++)
                    {
                       buf[j]=replace[k];
                        j++;
                   }   
                  
                }              
            }
               
        }  

    }
   
    
  }

fd=dup(1);

printf(1,"%s",buf);
//write(fd,buf, sizeof(buf));



  if (n < 0) {
    printf(1, "sed: read error\n");
    exit();
  }
  if(not_found==0)
  {
      printf(1, "sed: not found\n");
    exit();
  }
 
}

int main(int argc, char *argv[]) {
 // int fd, i;
 int fd;


 
//if not enough arguments pass nothing to sed
  if (argc <= 2) {
    sed(0, "", "", "");
    exit();
  }
//reading from the pipe
//cat test.txt | sed -replace -replaceWith
  if (argc == 3)
  {
      sed(0,"",argv[1], argv[2]);
      exit();
  }
  
  int i;

  //else reading from the file 
  //first check if we can open the file
  for (i = 3; i < argc; i++) {

    
    if ((fd = open(argv[i], 0)) < 0) {
      printf(1, "sed: cannot open %s\n", argv[i]);
      exit();
    }

   
    close(fd);
  }
  
 //passing arguments and the content of the file to sed
 //sed -replace -replaceWith test.txt
  fd = open(argv[3], 0);
  sed(fd,argv[3], argv[1], argv[2]);
  exit();
}
