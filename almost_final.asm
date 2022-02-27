IDEAL
MODEL small
STACK 100h
DATASEG

character 	dw 2, 2, 15, 15, 15, 15, 15, 15, 2, 2, 0, 2, 15, 2, 2, 2, 2, 2, 2, 15, 2, 0, 2, 15, 15, 2, 2, 2, 2, 2, 15, 2, 0, 2, 15, 2, 2, 15, 15, 2, 2, 15, 2, 0, 2, 15, 2, 2, 15, 15, 2, 2, 15, 2, 0, 2, 15, 2, 2, 2, 2, 2, 15, 15, 2, 0, 2, 15, 2, 15, 15, 2, 15, 15, 15, 2, 0, 2, 2, 15, 15, 15, 2, 2, 15, 2, 2, 0, 2, 2, 15, 2, 2, 2, 15, 2, 2, 2, 0, 2, 2, 15, 15, 15, 15, 15, 2, 2, 2, 1

score1 dw "cs", '$'
score2 dw "ro", '$'
score3 dw ":e", '$'
units dw '', '$'
dozens dw '', '$'
score dw 0

cube1 dw 200, 100, 3
cube2 dw 150, 100, 2
cube3 dw 100, 100, 3
cube4 dw 50, 100, 4

shot dw 20, 20, 0, 8
player dw 20, 20
player_dir db 0

mouse dw 0, 0

color db 15

CODESEG

proc enter_graphic_mode
    mov ax, 13h
    int 10h
    ret
endp

proc print_dot_from_memory
    push ax
	push bx
	push cx
	push dx

    mov cx, [si]
    mov al, [color]
    mov dx, [si + 2]
    mov bh, 0h
	mov ah, 0ch
    int 10h

	pop dx
	pop cx
	pop bx
	pop ax
    ret
endp

proc print_enemy
	mov di, offset character
	push ax
	push bx
	push cx
	push dx
	push [si]
	push [si + 2]
looop:
	mov ax, [di]
	cmp ax, 15
	jne compare
;	jmp Exit
	call print_dot_from_memory
	inc di
	inc di
	mov ax, [si]
	inc ax
	mov [si], ax
	jmp looop
compare:
	mov ax, [di]
	cmp ax, 2
	jne compare2
	mov ax, [si]
	inc ax
	mov [si], ax
	inc di
	inc di
	jmp looop
compare2:
	mov ax, [di]
	cmp ax, 0
	jne end_for
	mov ax, [si]
	sub ax, 10
	mov [si], ax
	mov ax, [si + 2]
	inc ax
	mov [si + 2], ax
	inc di
	inc di
	jmp looop
end_for:
	pop [si + 2]
	pop [si]
	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp

proc print_cube
	push ax
	push bx

	mov bx, 10h
up_10:
	call print_dot_from_memory
	mov ax, [si]
	inc ax
	mov [si], ax
	dec bx
	cmp bx, 0h
	jne up_10
	mov bx, 10h
right_10:
	call print_dot_from_memory
	mov ax, [si + 2]
	inc ax
	mov [si + 2], ax
	dec bx
	cmp bx, 0h
	jne right_10
	mov bx, 10h
down_10:
	call print_dot_from_memory
	mov ax, [si]
	dec ax
	mov [si], ax
	dec bx
	cmp bx, 0h
	jne down_10
	mov bx, 10h
left_10:
	call print_dot_from_memory
	mov ax, [si + 2]
	dec ax
	mov [si + 2], ax
	dec bx
	cmp bx, 0h
	jne left_10
	pop bx
	pop ax
	ret
endp

proc change_dir
	;comparing
	mov ax, [si]
	mov bx, [si + 2]
	mov cx, [si + 4]

	cmp cx, 1
	je dir_1

	cmp cx, 2
	je dir_2

	cmp cx, 3
	je dir_3

	cmp cx, 4
	je dir_4
	jmp continue

dir_1: ;two left one up
	mov [color], 0
	call print_enemy
	sub ax, 2
	dec bx
	mov [color], 15
	jmp continue

dir_2: ;two right one up
	mov [color], 0
	call print_enemy
	add ax, 2
	dec bx
	mov [color], 15
	jmp continue

dir_3: ;two left one down
	mov [color], 0
	call print_enemy
	sub ax, 2
	inc bx
	mov [color], 15
	jmp continue

dir_4: ;two right one down
	mov [color], 0
	call print_enemy
	add ax, 2
	inc bx
	mov [color], 15
	jmp continue


continue:
	mov [si], ax
	mov [si + 2], bx
	ret
endp

proc draw_player
	mov bx, 02h
position_start:
	dec [player]
	dec [player + 2]
	call print_dot_from_memory
	dec bx
	cmp bx, 0h
	jne position_start
	mov bx, 02h
	twice:
	mov cx, 04h
right_4:
	inc [player]
	call print_dot_from_memory
	dec cx
	cmp cx, 0h
	jne right_4
	inc [player + 2]
	call print_dot_from_memory
	mov cx, 04h
left_4:
	dec [player]
	call print_dot_from_memory
	dec cx
	cmp cx, 0h
	jne left_4
	inc [player + 2]
	call print_dot_from_memory
	dec bx
	cmp bx, 0h
	jne twice
	mov cx, 04h
last_right:
	inc [player]
	call print_dot_from_memory
	dec cx
	cmp cx, 0h
	jne last_right
	mov bx, 02h
position_end:
	dec [player]
	dec [player + 2]
	dec bx
	cmp bx, 0h
	jne position_end

ret
endp

proc player_change
	;; 04bh = left
	;; 04dh = right
	;; 050h = down
	;; 048h = up

    cmp [player_dir], 'a'
    je left_player

    cmp [player_dir], 'd'
    je right_player

    cmp [player_dir], 's'
    je down_player

    cmp [player_dir], 'w'
    je up_player

	jmp con_player
left_player:
	mov ax, [player]
	sub ax, 2
	mov [player], ax
    jmp con_player
right_player:
	mov ax, [player]
	add ax, 2
	mov [player], ax
    jmp con_player
down_player:
	mov ax, [player + 2]
	add ax, 2
	mov [player + 2], ax
    jmp con_player
up_player:
	mov ax, [player + 2]
	sub ax, 2
	mov [player + 2], ax
    jmp con_player
con_player:
    ret
endp

proc move_player
	mov si, offset player
	mov [color], 0
	call draw_player
	call player_change
	mov [color], 15
	call draw_player

	ret
endp

;proc random_x
;push ax
;push bx
;push cx
;
;mov ah, 0h
;int 1ah
;mov ax, dx
;xor dx, dx
;mov cx, 6
;div cx
;add dx, 01h
;cmp dx, 10h
;je sub6
;cmp dx, 09h
;je sub7
;cmp dx, 08h
;je sub7
;cmp dx, 07h
;je sub4
;cmp dx, 06h
;je sub2
;jmp nosub
;cmp dx, 05h
;je sub2
;sub7:
;sub dx, 07h
;jmp nosub
;sub6:
;sub dx, 06h
;jmp nosub
;sub4:
;sub dx, 04h
;jmp nosub
;sub2:
;sub dx, 02h
;jmp nosub
;nosub:
;pop cx
;pop bx
;pop ax
;ret
;endp
;proc assign_random
;call random_x
;mov [si + 4], dx
;ret
;endp

proc random
	push ax
	push bx
	push cx
	
	MOV AH, 00h  ; interrupts to get system time        
	INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

	mov  ax, dx
	xor  dx, dx
	mov  cx, 4  
	div  cx 
	inc  dx
   
	pop cx
	pop bx
	pop ax
	ret
endp

proc enemy_out_of_bounds
	mov [color], 0
	call print_enemy
	mov [color], 15

	mov bx, 308
	cmp [si], bx
	jl enemy_left
	mov ax, 3
	mov [si], ax
enemy_left:
	mov bx, 2
	cmp [si], bx
	ja enemy_right
	mov ax, 307
	mov [si], ax
enemy_right:
	mov bx, 188
	cmp [si + 2], bx
	jl enemy_above
	mov ax, 3
	mov [si + 2], ax
enemy_above:
	mov bx, 2
	cmp [si + 2], bx
	ja enemy_below
	mov ax, 187
	mov [si + 2], ax
enemy_below:
	call print_enemy
	ret
endp

proc calc_incline_2
	cmp cx, 0
	je case_0
	cmp cx, 1
	je case_1
	cmp cx, 2
	je case_2
	cmp cx, 3
	je case_3

case_0:
	mov ax, [mouse]
	mov bx, [mouse + 2]

	sub ax, [player]
	sub bx, [player + 2]
	mov cx, 4
	jmp cases_over
case_1:
	mov ax, [player]
	mov bx, [mouse + 2]

	sub ax, [mouse]
	sub bx, [player + 2]
	mov cx, 5
	jmp cases_over
case_2:
	mov ax, [mouse]
	mov bx, [player + 2]

	sub ax, [player]
	sub bx, [mouse + 2]
	mov cx, 6
	jmp cases_over
case_3:
	mov ax, [player]
	mov bx, [player + 2]

	sub ax, [mouse]
	sub bx, [mouse + 2]
	mov cx, 7
	jmp cases_over
cases_over:
	mov dx, 0
	div bx

	ret
endp

proc calc_shot_incline

	mov ax, 0
	mov bx, 0
	mov cx, 0
	mov ax, [mouse + 2]
	mov bx, [mouse]

	cmp ax, [player + 2]
	jl mouse_lower
	cmp bx, [player]
	jl mouse_left

	sub ax, [player + 2]
	sub bx, [player]
	mov cx, 0
	jmp divide

mouse_left:
	mov bx, [player]
	sub ax, [player + 2]
	sub bx, [mouse]
	mov cx, 1
	jmp divide

mouse_lower:
	cmp bx, [player]
	jl mouse_lower_left
	mov ax, [player + 2]
	sub ax, [mouse + 2]
	sub bx, [player]
	mov cx, 2
	jmp divide

mouse_lower_left:
	mov ax, [player + 2]
	mov bx, [player]
	sub ax, [mouse + 2]
	sub bx, [mouse]
	mov cx, 3
	jmp divide

divide:
	mov dx, 0
	div bx

	cmp ax, 0
	jne good_incline

	call calc_incline_2

good_incline:
	cmp ax, 4
	jl incline_not_too_high
	mov ax, 4
incline_not_too_high:
	mov [shot + 4], ax
	mov [shot + 6], cx

	ret
endp

proc move_shot
	mov si, offset shot
	mov [color], 0
	call print_dot_from_memory
	mov [color], 15

	mov cx, [shot + 6]
	mov ax, [shot]
	mov bx, [shot + 2]

	cmp cx, 0
	je case0
	cmp cx, 1
	je case1
	cmp cx, 2
	je case2
	cmp cx, 3
	je case3
	cmp cx, 4
	je case4
	cmp cx, 5
	je case5
	cmp cx, 6
	je case6
	cmp cx, 7
	je case7
	jmp no_case

case0:
	inc ax
	add bx, [shot + 4]
	jmp no_case
case1:
	dec ax
	add bx, [shot + 4]
	jmp no_case
case2:
	inc ax
	sub bx, [shot + 4]
	jmp no_case
case3:
	dec ax
	sub bx, [shot + 4]
	jmp no_case
case4:
	inc bx
	add ax, [shot + 4]
	jmp no_case
case5:
	inc bx
	sub ax, [shot + 4]
	jmp no_case
case6:
	dec bx
	add ax, [shot + 4]
	jmp no_case
case7:
	dec bx
	sub ax, [shot + 4]
no_case:
	mov [shot], ax
	mov [shot + 2], bx
	mov si, offset shot
	call print_dot_from_memory
	ret
endp

proc display_score
	mov ah, 02h
	mov bh, 00h
	mov dh, 00h
	mov dl, 020h
	int 10h
	
	mov ah, 09h
	
	lea dx, [score1]
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 00h
	mov dl, 022h
	int 10h
	
	mov ah, 09h
	
	lea dx, [score2]
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 00h
	mov dl, 024h
	int 10h
	
	mov ah, 09h
	
	lea dx, [score3]
	int 21h
	
	mov ax, [score]
	mov bx, 10
	mov dx, 0
	div bx
	
	add ax, 30h
	add dx, 30h
	
	mov [dozens], ax
	mov [units], dx
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 00h
	mov dl, 026h
	int 10h
	
	mov ah, 09h
	
	lea dx, [dozens]
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 00h
	mov dl, 027h
	int 10h
	
	mov ah, 09h
	
	lea dx, [units]
	int 21h
	
	ret
endp

proc shot_collsion_detection
	mov ax, [si]
	mov bx, [si + 2]
	
	cmp [shot], ax
	jl no_collision
	
	add ax, 12
	cmp [shot], ax
	ja no_collision


	cmp [shot + 2], bx
	jl no_collision
	add bx, 12
	cmp [shot + 2], bx
	ja no_collision
	
	mov [color], 0
	call print_enemy
	mov [color], 15
	
	mov ax, 8
	mov bx, 0
	
	mov [shot + 4], bx
	mov [shot + 6], ax

	call random
	mov [si + 4], dx

	mov cx, 10
	
	call random
	mov ax, dx
	mul cx
	mov [si], ax
	call random
	mov ax, dx
	mul cx
	mov [si + 2], ax
	
	mov si, offset shot
	mov [color], 0
	call print_dot_from_memory
	mov [color], 15
	mov ax, [player]
	mov bx, [player + 2]
	
	mov [shot], ax
	mov [shot + 2], bx
	
	mov ax, [score]
	inc ax
	mov [score], ax
no_collision:
	
	ret
endp

proc shot_out_of_bounds
	mov ax, [player]
	mov bx, [player + 2]

	cmp [shot], 314
	jl shot_left
	mov si, offset shot
	mov [color], 0
	call print_dot_from_memory
	mov [color], 15
	mov [shot], ax
	mov [shot + 2], bx
	mov [shot + 4], 0
	mov [shot + 6], 8
shot_left:
	cmp [shot], 2
	ja shot_right
	mov si, offset shot
	mov [color], 0
	call print_dot_from_memory
	mov [color], 15
	mov [shot], ax
	mov [shot + 2], bx
	mov [shot + 4], 0
	mov [shot + 6], 8
shot_right:
	cmp [shot + 2], 194
	jl shot_above
	mov si, offset shot
	mov [color], 0
	call print_dot_from_memory
	mov [color], 15
	mov [shot], ax
	mov [shot + 2], bx
	mov [shot + 4], 0
	mov [shot + 6], 8
shot_above:
	cmp [shot + 2], 2
	ja shot_below
	mov si, offset shot
	mov [color], 0
	call print_dot_from_memory
	mov [color], 15
	mov [shot], ax
	mov [shot + 2], bx
	mov [shot + 4], 0
	mov [shot + 6], 8
shot_below:
	ret
endp

proc player_collision_detection
	mov ax, [si]
	mov bx, [si + 2]
	
	cmp [player], ax
	jl collision_not_detected
	
	add ax, 12
	cmp [player], ax
	ja collision_not_detected


	cmp [player + 2], bx
	jl collision_not_detected
	add bx, 12
	cmp [player + 2], bx
	ja collision_not_detected
	jmp Exit
collision_not_detected:
	ret
endp

proc color_pixel
    call enter_graphic_mode

next:

	MOV     CX, 01H
	MOV     DX, 44H
	MOV     AH, 86H
	INT     15H

	push cx
	push dx
	push ax
	mov bx, 10h
	mov ax, 0001h
	int 33h
	mov ax, 0003h
	int 33h
	mov [mouse + 2], dx
	mov ax, cx
	sar ax, 1
	mov [mouse], ax
	pop ax
	pop dx
	pop cx

	cmp bx, 1
	jne no_click
	mov si, offset shot
	mov [color], 0
	call print_dot_from_memory
	mov [color], 15
	mov ax, [player]
	mov bx, [player + 2]
	mov [shot], ax
	mov [shot + 2], bx
	call calc_shot_incline
no_click:

	cmp [shot + 6], 8
	jne shot_shot
	mov ax, [player]
	mov bx, [player + 2]
	mov [shot], ax
	mov [shot + 2], bx
shot_shot:
	mov si, offset player
	call draw_player
	mov si, offset shot
	call print_dot_from_memory
	call shot_out_of_bounds
	call move_shot
	mov ah, 01h
	int 16h
	jnz pressed
	jz not_pressed
pressed:
	mov ah, 0h
	int 16h
	mov [player_dir], al
	call move_player
	call draw_player
not_pressed:

	mov si, offset cube1
	call enemy_out_of_bounds

	mov si, offset cube2
	call enemy_out_of_bounds

	mov si, offset cube3
	call enemy_out_of_bounds

	mov si, offset cube4
	call enemy_out_of_bounds

	mov si, offset cube1
	call print_enemy
	mov si, offset cube2
	call print_enemy
	mov si, offset cube3
	call print_enemy
	mov si, offset cube4
	call print_enemy

	mov si, offset cube1
	call change_dir
	mov si, offset cube2
	call change_dir
	mov si, offset cube3
	call change_dir
	mov si, offset cube4
	call change_dir

	mov si, offset cube1
	call print_enemy
	mov si, offset cube2
	call print_enemy
	mov si, offset cube3
	call print_enemy
	mov si, offset cube4
	call print_enemy

	mov si, offset cube1
	call player_collision_detection

	mov si, offset cube2
	call player_collision_detection

	mov si, offset cube3
	call player_collision_detection

	mov si, offset cube4
	call player_collision_detection

	mov si, offset cube1
	call shot_collsion_detection

	mov si, offset cube2
	call shot_collsion_detection

	mov si, offset cube3
	call shot_collsion_detection

	mov si, offset cube4
	call shot_collsion_detection

	mov si, offset shot
	call print_dot_from_memory

	call display_score

	jmp next
    ret
endp

Start:
    mov ax, @data
    mov ds, ax

mov ax, 0000h
int 33h
	
;	mov si, offset cube1
;	call random
;	mov [si + 4], dx
;
;	mov cx, 10
;	
;	call random
;	mov ax, dx
;	mul cx
;	mov [si], ax
;	call random
;	mov ax, dx
;	mul cx
;	mov [si + 2], ax
;	
;	mov si, offset cube2
;	call random
;	mov [si + 4], dx
;
;	mov cx, 10
;	
;	call random
;	mov ax, dx
;	mul cx
;	mov [si], ax
;	call random
;	mov ax, dx
;	mul cx
;	mov [si + 2], ax
;	
;	mov si, offset cube3
;	call random
;	mov [si + 4], dx
;
;	mov cx, 10
;	
;	call random
;	mov ax, dx
;	mul cx
;	mov [si], ax
;	call random
;	mov ax, dx
;	mul cx
;	mov [si + 2], ax
;	
;	mov si, offset cube4
;	call random
;	mov [si + 4], dx
;
;	mov cx, 10
;	
;	call random
;	mov ax, dx
;	mul cx
;	mov [si], ax
;	call random
;	mov ax, dx
;	mul cx
;	mov [si + 2], ax

call color_pixel


Exit:
    mov ax, 4C00h
    int 21h
END start
