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

  movl n,%eax
  subl %ecx,%eax #indicele de accesat crescator

  movl i,%edx #nu merge fara registru
  movl %edx,(%edi,%eax,4) #mutare numar citit in vector

  loop citire_nr_noduri_loop
  ret

  ############ AFISARI ##################

citire_matrice:

  #prolog
  #pushl %ebp
  pusha
  movl %esp,%ebp


  lea nr_legaturi,%edi
  lea matrice,%esi

  #int i,j,a
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
    #popl %ebp
    popa
    ret

citire_cerinta_2:

  #prolog
  pushl %ebp
  movl %esp,%ebp

  pushl $lungime_drum
  pushl $scanare_numar
  call scanf
  popl %ebx
  popl %ebx

  pushl $nod_sursa
  pushl $scanare_numar
  call scanf
  popl %ebx
  popl %ebx

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

    movl n,%eax
    subl %ecx,%eax #indicele de accesat crescator

    pushl %ecx #salvare index

    #citire numar de legaturi
    pushl (%edi,%eax,4)
    #pushl %eax
    pushl $printare_numar_spatiu
    call printf
    popl %ebx
    popl %ebx
    #popl %ebx

    pushl $0
    call fflush
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
  movl %esp,%ebp

  #incarcare adresa matrice
  movl 8(%ebp),%edi
  #lea matrice,%edi

  #for(i = 0;i < n;i++){
    #for(j = 0; j < n; j++){
      #printf("%d ",matrice[i][j]);
    #}
    #puts("\n");
  #}

  #spatiu pt i,j
  subl $8,%esp

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

      #afisare pe ecran
      pushl $0
      call fflush
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
      pushl $printare_new_line
      call printf
      popl %ebx

      jmp for_i_af

  iesire_af:
  movl %ebp,%esp
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

  pushl $0
  call fflush
  popl %ebx

  #epilog
  movl %ebp,%esp
  popl %ebp
  ret

################## MATRIX MULTIPLY #################

matrix_mult:

  #epilog
  pushl %ebp
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


  #8(%ebp) - matrice
  #12(%ebp) - matrice2
  #16(%ebp) - matrice_rezultat
  #20(%ebp) - n
  #loc pentru variabile
  subl $12,%esp
  #-4(%ebp) - i
  #-8(%ebp) - j
  #-12(%ebp) - k

  movl $0,-4(%ebp)
  movl $0,-8(%ebp)
  movl $0,-12(%ebp)

  for_i_matrix:

    #i
    movl -4(%ebp),%eax
    #n
    movl n,%ebx
    cmp %eax,%ebx
    je iesire_matrix

    #j=0
    movl $0,-8(%ebp)

    for_j_matrix:

      #j
      movl -8(%ebp),%eax
      #n
      movl n,%ebx
      cmp %eax,%ebx
      je continue_matrix

      #k=0
      movl $0,-12(%ebp)

      #i*n+j
      movl -4(%ebp),%eax #i
      xorl %edx,%edx
      movl n,%ebx
      mull %ebx #i*n
      movl -8(%ebp),%ebx
      addl %ebx,%eax #i*n+j

      #matrice_rezultat[i][j] = 0
      movl 16(%ebp),%edi
      movl $0,(%edi,%eax,4)

      for_k_matrix:

        #k
        movl -12(%ebp),%eax
        #n
        movl n,%ebx
        cmp %eax,%ebx
        je continue_matrix_2


        #matrice[i][k]
        movl -4(%ebp),%eax
        xorl %edx,%edx
        movl n,%ecx
        mull %ecx
        movl -12(%ebp),%ebx #k
        addl %ebx,%eax #i*n+k
        movl 8(%ebp),%edi #matrice
        movl (%edi,%eax,4),%ecx #matrice[i][k]

        #pushl %ecx
        #pushl $printare_numar_spatiu
        #call printf
        #subl $4,%esp
        #subl $4,%esp


        #matrice2[k][j]
        movl -12(%ebp),%eax
        xorl %edx,%edx
        movl n,%ebx
        mull %ebx
        movl -8(%ebp),%ebx #j
        addl %ebx,%eax #k*n+j
        movl 12(%ebp),%edi#matrice2
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
        movl n,%ebx
        mull %ebx #i*n
        movl -8(%ebp),%ebx
        addl %ebx,%eax #i*n+j

        #matrice_rezultat[i][j] += matrice[i][k]*matrice2[k][j]
        movl 16(%ebp),%edi
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
  popl %ebp
  ret

#copiaza din prima matrice in a doua
#matrix_copy(m1,m2)
matrix_copy:

  #epilog
  pushl %ebp
  movl %esp,%ebp

  #8(%ebp) - m1
  #12(%ebp) - m2
  #memorie
  subl $8,%esp
  #-4(%ebp) - i
  #-8(%ebp) - j

  #int i,j
  #for(i = 0;i < n; i++){
  #  for(j = 0;j < n; j++){
  #    m2[i][j] = m1[i][j];
  #  }
  #}

  movl $0,-4(%ebp)
  movl $0,-8(%ebp)


  for_i_copy:

    movl -4(%ebp),%eax
    movl n,%ecx
    cmp %ecx,%eax
    je iesire_copiere

    movl $0,-8(%ebp)

    for_j_copy:

      movl -8(%ebp),%eax
      movl n,%ecx
      cmp %ecx,%eax
      je continue_copy

      movl -4(%ebp),%eax
      xorl %edx,%edx
      movl n,%ebx
      mull %ebx
      movl -8(%ebp),%ebx
      addl %ebx,%eax #[i][j]

      movl 8(%ebp),%edi #m1
      movl 12(%ebp),%esi #m2

      movl (%edi,%eax,4),%ebx
      movl %ebx,(%esi,%eax,4)

      movl -8(%ebp),%eax
      inc %eax
      movl %eax,-8(%ebp)
      jmp for_j_copy


    continue_copy:

      movl -4(%ebp),%eax
      inc %eax
      movl %eax,-4(%ebp)
      jmp for_i_copy


  iesire_copiere:
  movl %ebp,%esp
  popl %ebp
  ret


.global main
main:

call citire_nr_cerinta
call citire_n
call citire_nr_noduri
call citire_matrice

#DACA lungimea drumului e 1 trebuie verificat manual
movl $2,%ecx
movl nr_cerinta,%eax
cmp %ecx,%eax
je cerinta_2

cerinta_1:
  #call afisare_numar_nr_cerinta
  #call afisare_n
  #call afisare_nr_noduri
  pushl $matrice
  call afisare_matrice
  popl %ebx
  jmp  et_exit

cerinta_2:

  call citire_cerinta_2
  #call afisare_cerinta_2

  #copiere matrice->matrice2
  pushl $matrice2
  pushl $matrice
  call matrix_copy
  popl %ebx
  popl %ebx

  #verificam daca lungimea drumului e 1
  movl lungime_drum,%ecx
  movl $1,%ebx
  cmp %ebx,%ecx
  jne continue_cerinta_2
  #daca drumul e de lungime 1
  pushl $matrice_rezultat
  pushl $matrice
  call matrix_copy
  popl %ebx
  popl %ebx

  jmp cautare


  continue_cerinta_2:
  dec %ecx

  cerinta_2_loop:

    #salvare iteratii
    pushl %ecx
    #calculare matrice la putere
    pushl n
    pushl $matrice_rezultat
    pushl $matrice2
    pushl $matrice
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
    #call afisare_matrice
    #popl %ebx

    #copiere matrice_rezultat->matrice2
    pushl $matrice2
    pushl $matrice_rezultat
    call matrix_copy
    popl %ebx
    popl %ebx

    #restaurare iteratii
    popl %ecx

    loop cerinta_2_loop

  cautare:
  #cautare daca exista drun de lungime
  lea matrice_rezultat,%edi

  #matrice[nod_sursa][nod_destinatie]
  movl nod_sursa,%eax
  xorl %edx,%edx
  movl n,%ebx
  mull %ebx
  addl nod_destinatie,%eax

  #verificare existenta drum
  movl (%edi,%eax,4),%edx
  movl $1,%ecx
  cmp %ecx,%edx
  #daca nu exista cel putin un drum
  jl nu_exista

  #afisare numar de drumuri
  pushl lungime_drum
  #pushl $exitsa_drum
  pushl $printare_numar
  call printf
  popl %ebx
  popl %ebx
  jmp et_exit

  nu_exista:
  pushl $nu_exitsa_drum
  call puts
  popl %ebx



et_exit:
movl $1,%eax
xorl %ebx,%ebx
int $0x80
