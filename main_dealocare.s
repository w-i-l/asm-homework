.data
matrice: .space 40000 #matricea cu 10000 elemnte 100x100
matrice2: .space 40000 #matricea 2 cu 10000 elemnte 100x100
matrice_rezultat: .space 40000 #matricea rez cu 10000 elemnte 100x100
n: .space 4 #numar de noduri
nr_legaturi: .space 400 #vectorul ce retine numarul de legaturi pentru fiecare element
nr_cerinta: .space 4 #numarul cerintei
i: .space 4
nod_sursa: .space 4
nod_destinatie: .space 4
lungime_drum: .space 4

scanare_numar: .asciz "%ld"
printare_n: .asciz "nr_noduri: %ld\n"
printare_nr_cerinta: .asciz "nr_cerinta: %ld\n"
printare_nr_noduri: .asciz "nr_nod %ld: %ld\n"
printare_numar: .asciz "%ld\n"
printare_numar_spatiu: .asciz "%ld "
printare_new_line: .asciz "\n"
printare_noduri: .asciz "Numar noduri:"
exitsa_drum: .asciz "Exista drum de lungimea %ld!\n"
nu_exitsa_drum: .asciz "Nu exista drum!"


.text

################## CITIRI #################
citire_nr_cerinta:

  pushl $nr_cerinta
  pushl $scanare_numar
  call scanf
  popl %edx
  popl %edx
  ret

citire_n:
  pushl $n
  pushl $scanare_numar
  call scanf
  popl %edx
  popl %edx
  ret

citire_nr_noduri:

  movl n,%ecx #nr de iteratii
  leal nr_legaturi, %edi #vectorul cu numarul de nr_legaturi

  citire_nr_noduri_loop:
  pushl %ecx #salvare index

  #citire numar de legaturi
  pushl $i
  pushl $scanare_numar
  call scanf
  popl %ebx
  popl %ebx

  #restaurare valoare index
  popl %ecx

  #indicele de accesat crescator
  movl n,%eax
  subl %ecx,%eax

  #mutare numar citit in vector
  movl i,%edx
  movl %edx,(%edi,%eax,4)

  loop citire_nr_noduri_loop
  ret

  ############ AFISARI ##################
#citire_matrice(matrice,nr_legaturi)

citire_matrice:

  #prolog
  pushl %ebp
  pushl %ebx
  pushl %edi
  pushl %esi

  movl %esp,%ebp

  #20(%ebp) - matrice
  #24(%ebp) - nr_legaturi

  movl 20(%ebp),%esi
  movl 24(%ebp),%edi

  #simulam
  #int i,j,a;
  #for(i = 0; i < n; i++){
    #for(j = 0; j < nr_legaturi[i]; j++){
      #scanf("%d",&a);
      #matrice[i][a] = 1;
    #}
    #}

  #spatiu pentru variabile
  subl $12,%esp
  #-4(%ebp) - i
  #-8(%ebp) - j
  #-12(%ebp) - a

  #initializare
  movl $0, -4(%ebp)
  movl $0, -8(%ebp)
  movl $0, -12(%ebp)

  for_i:

    #i
    movl -4(%ebp),%eax
    movl n,%ebx
    #i<n
    cmp %eax,%ebx
    je iesire

    #j=0
    movl $0, -8(%ebp)

    for_j:

      #j
      movl -8(%ebp),%eax
      #i
      movl -4(%ebp),%ebx
      #nr_legaturi[i]
      movl (%edi,%ebx,4),%ecx
      #j<nr_legaturi[i]
      cmp %ecx,%eax
      je continue

      #a
      lea -12(%ebp),%eax

      #citire a
      pushl %eax
      pushl $scanare_numar
      call scanf
      popl %ebx
      popl %ebx


      #accesare matrice[i][a] -- #i*n+a
      movl -4(%ebp),%eax #i
      movl n,%ecx #n
      xorl %edx,%edx
      mull %ecx #i*n
      addl -12(%ebp),%eax #i*n+a
      movl $1,(%esi,%eax,4)

      #j
      movl -8(%ebp),%eax
      inc %eax #j+1
      movl %eax,-8(%ebp)
      jmp for_j


  continue:
    #i
    movl -4(%ebp),%ebx
    #i+1
    inc %ebx
    movl %ebx,-4(%ebp)


    jmp for_i

  #epilog
  iesire:
    movl %ebp,%esp
    popl %esi
    popl %edi
    popl %ebx
    popl %ebp
    #popa
    ret

citire_cerinta_2:

  #prolog
  pushl %ebp
  movl %esp,%ebp

  #citire lungime drum
  pushl $lungime_drum
  pushl $scanare_numar
  call scanf
  popl %ebx
  popl %ebx

  #citire nod initial
  pushl $nod_sursa
  pushl $scanare_numar
  call scanf
  popl %ebx
  popl %ebx

  #citire nod final
  pushl $nod_destinatie
  pushl $scanare_numar
  call scanf
  popl %ebx
  popl %ebx

  #epilog
  movl %ebp,%esp
  popl %ebp
  ret

################## AFISARI #################

afisare_numar_nr_cerinta:

  pushl nr_cerinta
  pushl $printare_nr_cerinta
  call printf
  popl %edx
  popl %edx
  ret

afisare_n:

  pushl n
  pushl $printare_n
  call printf
  popl %edx
  popl %edx
  ret

#AFISARE NUMAR NODURI
#afisare noduri
#de ce nu merge daca l pun dupa movl?
afisare_nr_noduri:

  #Prinatre Numar Noduri
  pushl $printare_noduri
  call puts
  popl %ebx

  movl n,%ecx #nr de iteratii
  leal nr_legaturi, %edi #vectorul cu numarul de nr_legaturi
  afisare_nr_noduri_loop:

    #indicele de accesat crescator
    movl n,%eax
    subl %ecx,%eax

    #salvare index
    pushl %ecx

    #citire numar de legaturi
    pushl (%edi,%eax,4)
    #pushl %eax
    pushl $printare_numar_spatiu
    call printf
    popl %ebx
    popl %ebx
    #popl %ebx

    pushl $printare_new_line
    call  printf
    popl %ebx

    #restaurare valoare index
    popl %ecx

    loop afisare_nr_noduri_loop

    #new line
    pushl $printare_new_line
    call puts
    popl %ebx

    ret

afisare_matrice:

  #prolog
  pushl %ebp
  pushl %edi
  pushl %ebx
  movl %esp,%ebp

  #incarcare adresa matrice
  movl 16(%ebp),%edi
  #lea matrice,%edi

  #for(i = 0;i < n;i++){
    #for(j = 0; j < n; j++){
      #printf("%d ",matrice[i][j]);
    #}
    #puts("\n");
  #}

  #spatiu pt i,j
  subl $8,%esp

  ; pusha
  #-4(%ebp) - i
  #-8(%ebp) - j

  #initializare
  movl $0,-4(%ebp)
  movl $0,-8(%ebp)

  for_i_af:

    #verificare conditie loop
    #i
    movl -4(%ebp),%eax
    #n
    movl n,%ebx
    #i<n
    cmp %eax,%ebx
    je iesire_af

    #j=0
    movl $0,-8(%ebp)

    for_j_af:

      #verificare conditie loop
      #j
      movl -8(%ebp),%eax
      #n
      movl n,%ebx
      #j<n
      cmp %eax,%ebx
      je continue_af

      # preluare element matrice[i][j] -- #i*n+j
      #i
      movl -4(%ebp),%eax
      xorl %edx,%edx
      #n
      movl n,%ebx
      #i*n
      mull %ebx
      #j
      movl -8(%ebp),%ecx
      #i*n+j
      addl %ecx,%eax
      #matrice[i][j]
      movl (%edi,%eax,4),%ebx

      #afisare matrice[i][j]
      pushl %ebx
      pushl $printare_numar_spatiu
      call printf
      popl %ebx
      popl %ebx

      #j
      movl -8(%ebp),%eax
      #j+1
      inc %eax
      movl %eax,-8(%ebp)
      jmp for_j_af

    continue_af:

      #i
      movl -4(%ebp),%eax
      #i+1
      inc %eax
      movl %eax,-4(%ebp)

      #new line de la afisare
      #afisare fara fflush
      pushl $printare_new_line
      call printf
      popl %ebx

      jmp for_i_af

  iesire_af:
  ; popa
  movl %ebp,%esp#restaurare esp
  popl %ebx
  popl %edi
  popl %ebp

  ret

afisare_cerinta_2:
  #prolog
  pushl %ebp
  movl %esp,%ebp

  pushl lungime_drum
  pushl $printare_numar_spatiu
  call printf
  popl %ebx
  popl %ebx

  pushl nod_sursa
  pushl $printare_numar_spatiu
  call printf
  popl %ebx
  popl %ebx

  pushl nod_destinatie
  pushl $printare_numar_spatiu
  call printf
  popl %ebx
  popl %ebx

  pushl $printare_new_line
  call  printf
  popl %ebx
  #epilog
  movl %ebp,%esp
  popl %ebp
  ret

################## MATRIX MULTIPLY #################

matrix_mult:

  #epilog
  pushl %ebp
  pushl %ebx
  pushl %edi
  movl %esp,%ebp

    #int i,j,k
    #for (i = 0; i < n; i++) {
    #    for (j = 0; j < n; j++) {
    #        c[i][j] = 0;
    #        for (k = 0; k < n; k++) {
    #            c[i][j] += a[i][k] * b[k][j];
    #        }
    #    }
    #}


  #16(%ebp) - matrice
  #20(%ebp) - matrice2
  #24(%ebp) - matrice_rezultat
  #28(%ebp) - n

  #loc pentru variabile
  subl $12,%esp
  #-4(%ebp) - i
  #-8(%ebp) - j
  #-12(%ebp) - k

  #initializare
  movl $0,-4(%ebp)
  movl $0,-8(%ebp)
  movl $0,-12(%ebp)

  for_i_matrix:

    #i
    movl -4(%ebp),%eax
    #n
    movl 28(%ebp),%ebx
    cmp %eax,%ebx
    je iesire_matrix

    #j=0
    movl $0,-8(%ebp)

    for_j_matrix:

      #j
      movl -8(%ebp),%eax
      #n
      movl 28(%ebp),%ebx
      cmp %eax,%ebx
      je continue_matrix

      #k=0
      movl $0,-12(%ebp)

      #i*n+j
      movl -4(%ebp),%eax #i
      xorl %edx,%edx
      movl 28(%ebp),%ebx
      mull %ebx #i*n
      movl -8(%ebp),%ebx
      addl %ebx,%eax #i*n+j

      #matrice_rezultat[i][j] = 0
      movl 24(%ebp),%edi
      movl $0,(%edi,%eax,4)

      for_k_matrix:

        #k
        movl -12(%ebp),%eax
        #n
        movl 28(%ebp),%ebx
        cmp %eax,%ebx
        je continue_matrix_2


        #matrice[i][k]
        movl -4(%ebp),%eax
        xorl %edx,%edx
        movl 28(%ebp),%ecx
        mull %ecx
        movl -12(%ebp),%ebx #k
        addl %ebx,%eax #i*n+k
        movl 16(%ebp),%edi #matrice
        movl (%edi,%eax,4),%ecx #matrice[i][k]

        #pushl %ecx
        #pushl $printare_numar_spatiu
        #call printf
        #subl $4,%esp
        #subl $4,%esp


        #matrice2[k][j]
        movl -12(%ebp),%eax
        xorl %edx,%edx
        movl 28(%ebp),%ebx
        mull %ebx
        movl -8(%ebp),%ebx #j
        addl %ebx,%eax #k*n+j
        movl 20(%ebp),%edi#matrice2
        movl (%edi,%eax,4),%ebx #matrice2[i][k]

        #pushl %ebx
        #pushl $printare_numar
        #call printf
        #subl $4,%esp
        #subl $4,%esp

        movl %ecx,%eax
        xorl %edx,%edx
        mull %ebx
        movl %eax,%ecx #matrice[i][k]*matrice2[k][j]

        #i*n+j
        movl -4(%ebp),%eax #i
        xorl %edx,%edx
        movl 28(%ebp),%ebx
        mull %ebx #i*n
        movl -8(%ebp),%ebx
        addl %ebx,%eax #i*n+j

        #matrice_rezultat[i][j] += matrice[i][k]*matrice2[k][j]
        movl 24(%ebp),%edi
        movl (%edi,%eax,4),%ebx
        addl %ecx,%ebx
        movl %ebx,(%edi,%eax,4)

        #k
        movl -12(%ebp),%eax
        inc %eax
        movl %eax,-12(%ebp)
        jmp for_k_matrix

        continue_matrix_2:
        #j
        movl -8(%ebp),%eax
        inc %eax
        movl %eax,-8(%ebp)
        jmp for_j_matrix

    continue_matrix:

      #i
      movl -4(%ebp),%eax
      inc %eax
      movl %eax,-4(%ebp)
      jmp for_i_matrix


  iesire_matrix:


    #movl 20(%ebp),%eax
    #pushl %eax
    #pushl $printare_n
    #call printf
    #popl %ebx
    #popl %ebx


  movl %ebp,%esp
  popl %edi
  popl %ebx
  popl %ebp
  ret

#copiaza din prima matrice in a doua
#matrix_copy(m1,m2)
matrix_copy:

  #epilog
  pushl %ebp
  pushl %ebx
  pushl %edi
  pushl %esi
  movl %esp,%ebp

  #20(%ebp) - m1
  #24(%ebp) - m2

  #spatiu pentru variabile
  subl $8,%esp
  #-4(%ebp) - i
  #-8(%ebp) - j

  #int i,j
  #for(i = 0;i < n; i++){
  #  for(j = 0;j < n; j++){
  #    m2[i][j] = m1[i][j];
  #  }
  #}

  #initializare
  movl $0,-4(%ebp)
  movl $0,-8(%ebp)


  for_i_copy:

    #i
    movl -4(%ebp),%eax
    movl n,%ecx
    #i<n
    cmp %ecx,%eax
    je iesire_copiere

    #j=0
    movl $0,-8(%ebp)

    for_j_copy:

      #j
      movl -8(%ebp),%eax
      movl n,%ecx
      #j<n
      cmp %ecx,%eax
      je continue_copy

      #i*n+j
      #i
      movl -4(%ebp),%eax
      xorl %edx,%edx
      movl n,%ebx
      #i*n
      mull %ebx
      movl -8(%ebp),%ebx
      #i*n+j
      addl %ebx,%eax

      movl 20(%ebp),%edi #m1
      movl 24(%ebp),%esi #m2

      #m2[i][j] = m1[i][j]
      movl (%edi,%eax,4),%ebx
      movl %ebx,(%esi,%eax,4)

      #j+1
      movl -8(%ebp),%eax
      inc %eax
      movl %eax,-8(%ebp)
      jmp for_j_copy


    continue_copy:

      #i+1
      movl -4(%ebp),%eax
      inc %eax
      movl %eax,-4(%ebp)
      jmp for_i_copy


  iesire_copiere:
  #epilog
  movl %ebp,%esp
  popl %esi
  popl %edi
  popl %ebx
  popl %ebp
  ret

################## GASIRE DRUMURI #################

#rezolvare_cerinta(m1,m2,mrez,n)
rezolvare_cerinta:

  #prolog
  pushl %ebp
  pushl %ebx
  pushl %edi
  pushl %esi
  movl %esp,%ebp

  #20(%ebp) - matrice
  #24(%ebp) - matrice2
  #28(%ebp) - matrice_rezultat
  #32(%ebp) - n


  call citire_cerinta_2
  #call afisare_cerinta_2


  #copiere matrice->matrice2
  pushl 24(%ebp)
  pushl 20(%ebp)
  call matrix_copy
  popl %ebx
  popl %ebx

  #verificam daca lungimea drumului e 1
  movl lungime_drum,%ecx
  movl $1,%ebx
  cmp %ebx,%ecx
  jne acontinue_cerinta_2
  #daca drumul e de lungime 1
  #rezolvam cerinta pe matricea citita
  pushl 28(%ebp)
  pushl 20(%ebp)
  call matrix_copy
  popl %ebx
  popl %ebx

  jmp acautare


  acontinue_cerinta_2:
  dec %ecx

  acerinta_2_loop:

    #salvare iteratii
    pushl %ecx
    #calculare matrice la putere
    pushl 32(%ebp)
    pushl 28(%ebp)
    pushl 24(%ebp)
    pushl 20(%ebp)
    call matrix_mult
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    #afisare new_line
    #pushl $printare_new_line
    #call printf
    #popl %ebx

    #afisare rezultat matrice
    #pushl $matrice_rezultat
    #pushl 28(%ebp)
    #call afisare_matrice
    #popl %ebx

    #copiere matrice_rezultat->matrice2
    pushl 24(%ebp)
    pushl 28(%ebp)
    call matrix_copy
    popl %ebx
    popl %ebx

    #restaurare iteratii
    popl %ecx

    loop acerinta_2_loop

  acautare:
  #cautare daca exista drun de lungime

  #matrice_rezultat
  movl 28(%ebp),%edi

  #[nod_sursa][nod_destinatie]
  movl nod_sursa,%eax
  xorl %edx,%edx
  #n
  movl 32(%ebp),%ebx
  mull %ebx
  #nod_sursa*n + nod_destinatie
  addl nod_destinatie,%eax

  #verificare existenta drum
  #matrice_rezultat[nod_sursa][nod_destinatie]
  movl (%edi,%eax,4),%edx
  movl $1,%ecx
  cmp %ecx,%edx
  #daca nu exista cel putin un drum
  jl anu_exista

  #afisare numar de drumuri
  #pushl lungime_drum
  pushl %edx
  #pushl $exitsa_drum
  pushl $printare_numar
  call printf
  popl %ebx
  popl %ebx
  jmp iesire_cautare

  anu_exista:
  pushl $nu_exitsa_drum
  call puts
  popl %ebx

  iesire_cautare:
    #epilog
    movl %ebp,%esp
    popl %esi
    popl %edi
    popl %ebx
    popl %ebp
    ret

.global main
main:

#citim datele problemei
call citire_nr_cerinta
call citire_n
call citire_nr_noduri

pushl $nr_legaturi
pushl $matrice
call citire_matrice
popl %ebx
popl %ebx


movl $2,%ecx
movl nr_cerinta,%eax
cmp %ecx,%eax
je cerinta_2
movl $3,%ecx
cmp %ecx,%eax
je cerinta_3


cerinta_1:
  #call afisare_numar_nr_cerinta
  #call afisare_n
  #call afisare_nr_noduri
  pushl $matrice
  call afisare_matrice
  popl %ebx
  jmp  et_exit

cerinta_2:

  pushl n
  pushl $matrice_rezultat
  pushl $matrice2
  pushl $matrice
  call rezolvare_cerinta
  popl %ebx
  popl %ebx
  popl %ebx
  popl %ebx

  jmp et_exit

cerinta_3:
  #alocam dinamic matricile
  m_rez:

  #pushl $matrice
  #call afisare_matrice
  #popl %ebx

  #calculam numarul de bytes necesar alocarii si il salvam
  movl n,%eax
  movl n,%ebx
  xorl %edx,%edx
  mull %ebx #n*n
  movl $4,%ebx
  mull %ebx
  movl %eax,i

  #rezolvare_cerinta(matrice,matrice2,matrice_rezultat,#n)
  pushl n

  #alocare dinamica pt
  #matrice_rezultat
  mov $192,%eax #mmap2
  mov $0x0,%ebx #let the os pick the starting adress
  mov i,%ecx #n*n*4bytes
  mov $0x3,%edx #PROT_READ | PROT_WRITE
  mov $0x22,%esi #MAP_ANONYMUS | MAP_PRIVATE
  mov $0,%edi #all bytes 0
  mov $0,%ebp # 0
  int $0x80

  #pushl %eax
  #call afisare_matrice
  #popl %ebx

  #rezolvare_cerinta(matrice,matrice2,#matrice_rezultat,n)
  pushl %eax

  m2:
  #alocare dinamica pt
  #matrice2
  mov $192,%eax #mmap2
  mov $0x0,%ebx #let the os pick the starting adress
  mov i,%ecx #n*n*4bytes
  mov $0x3,%edx #PROT_READ | PROT_WRITE
  mov $0x22,%esi #MAP_ANONYMUS | MAP_PRIVATE
  mov $0,%edi #all bytes 0
  mov $0,%ebp # 0
  int $0x80

  #copiem valoarea din matricea citita din fisier
  #in matricea alocata dinamica
  pushl %eax
  pushl $matrice
  call matrix_copy
  popl %ebx
  popl %eax

  #pushl %eax
  #call afisare_matrice
  #popl %ebx


  #rezolvare_cerinta(matrice,#matrice2,matrice_rezultat,n)
  pushl %eax

  m1:
  #alocare dinamica pt
  #matrice
  mov $192,%eax #mmap2
  mov $0x0,%ebx #let the os pick the starting adress
  mov i,%ecx #n*n*4bytes
  mov $0x3,%edx #PROT_READ | PROT_WRITE
  mov $0x22,%esi #MAP_ANONYMUS | MAP_PRIVATE
  mov $0,%edi #all bytes 0
  mov $0,%ebp # 0
  int $0x80

  #pushl %eax
  #call afisare_matrice
  #popl %ex

  #copiem valoarea din matricea citita din fisier
  #in matricea alocata dinamica
  pushl %eax
  pushl $matrice
  call matrix_copy
  popl %ebx
  popl %eax

  #rezolvare_cerinta(#matrice,matrice2,matrice_rezultat,n)
  pushl %eax

  apelare:
  call rezolvare_cerinta
  #n

  #matrice
  popl %ebx
  #dealocare memorie pt matrice
  movl $91,%eax #cod munmap
  movl i,%ecx #nr bytes de dealocat
  int $0x80

  #matrice2
  popl %ebx
  #dealocare memorie pt matrice
  movl $91,%eax #cod munmap
  movl i,%ecx #nr bytes de dealocat
  int $0x80

  #matrice_rezultat
  popl %ebx
  #dealocare memorie pt matrice
  movl $91,%eax #cod munmap
  movl i,%ecx #nr bytes de dealocat
  int $0x80

  #n
  popl %ebx


et_exit:
movl $1,%eax
xorl %ebx,%ebx
int $0x80