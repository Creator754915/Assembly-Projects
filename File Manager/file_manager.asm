
; Assembly File Manager 
; by Creator754915
; version 1.0

section .data
    msg db 'Bienvenue sur ASM File Manager', 0xA
    msg_len equ $ - msg

    ask_action db 'Action (1 = create, 99 = quit): ', 0
    ask_action_len equ $ - ask_action

    ask_filename db 'Nom du fichier: ', 0
    ask_filename_len equ $ - ask_filename

section .bss
    filename resb 25               ; réserve 25 bytes pour filename
    action resb 3                  ; réserve 3 bytes pour action
    fd_out resb 1                  ; réserve 1 byte pour fd_out

section .text
    global _start


_start:
    mov eax, 4                     ; appele du sytème pour sys_write (4)
    mov ebx, 1                     ; nombre 1 pour stdout => équivalent de print
    mov ecx, msg                   ; adresse du message msg
    mov edx, msg_len               ; longeur du message msg
    int 0x80                       ; intéruption du kernel pour write

    mov eax, 4
    mov ebx, 1
    mov ecx, ask_action
    mov edx, ask_action_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, action
    mov edx, 3
    int 0x80

    cmp byte [action], '1'
    jne check_quit
    cmp byte [action+1], 0xA
    jne check_quit
    jmp create_file

check_quit:
    cmp byte [action], '9'
    jne restart
    cmp byte [action+1], '9'
    jne restart
    cmp byte [action+2], 0xA
    jne restart
    jmp quit

restart:
    jmp _start                      ; boucle infinie sur _start

create_file:
    ; récupèrer le nom du fichier
    mov eax, 4
    mov ebx, 1
    mov ecx, ask_filename
    mov edx, ask_filename_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, filename
    mov edx, 25
    int 0x80

    ; Nettoyage du \n à la fin 
    mov ecx, filename
    jmp clean_input

clean_input:
    mov al, [ecx]
    cmp al, 0
    je done_clean
    cmp al, 0xA
    je replace_and_done
    inc ecx
    jmp clean_input                ; boucle sur clean_input si chaine non finie

replace_and_done:
    mov byte [ecx], 0

done_clean:

    ; creation du fichier
    mov  eax, 8                    ; créer le fichier
    mov  ebx, filename             ; le fichier aura pour nom filename (la valeur)
    mov  ecx, 0777                 ; lu, ecrit et peut être exécuté par tout le monde
    int  0x80                      ; appele du kernel
    mov [fd_out], eax

    ; écrit dans le fichier créé
    mov eax, 4
    mov ebx, [fd_out]
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    ; ferme le fichier
    mov eax, 6
    mov ebx, [fd_out]
    int 0x80

    jmp _start                   

quit:
    mov eax, 1                     ; appele du système sys_exit (1)
    xor ebx, ebx                   ; retourne 0
    int 0x80                       ; appele du kernel pour sortir
