[General]
SyntaxVersion=2
BeginHotkey=9
BeginHotkeyMod=0
PauseHotkey=120
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=a6ddc73c-64b1-4785-b826-9e6f194da175
Description=xjbd
Enable=1
AutoRun=0
[Repeat]
Type=1
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
Dim target_person
Dim need_apple,jump_dialog_enable
Dim only_fight
Dim fight_plan
Dim select_dungeous
Dim ap_enought
Dim changeMember1  //1-3
Dim changeMember2//1-3
Dim log_str
Dim tmp,i
Dim tempP1x, tempP1y, tempP2x, tempP2y
Dim timeout,timeout_limit,reboot_enable
Dim skillDefaultColor(9)
Dim skillDefaultPosX//(9)
Dim skillDefaultPosY
Dim houguReadyP1, houguReadyP2, houguReadyP3
Dim costumePosX,costumePosY//(7)
Dim skillState(9),skillUseable(9)
Dim fight_turn
Dim skill_cd(9),skill_eb_turn(9),hougu_eb_turn(3),costume_eb(3),costume_use(3),skill_double,skill_person(9)
Dim costume_order_change
Dim fight_target(9) //9 turn 超出9回合不管了
Dim mission_screen_x(6),mission_screen_y(6) //选关界面 找4个点
Dim mission_screen_c(6)
Dim wait_ap_enought ,wait_start_fight

wait_ap_enought = 600000
wait_start_fight = 1000
need_apple = 1//1自动吃果子 0不吃
only_fight = 0 //1只战斗 0完整流程
select_dungeous = 1//0是diy的副本位置 大于0是前4个
fight_plan = 3//0默认 1 红A 2水着莉莉丝 3非换人临时 4换人临时 5随便加了技能cd 6 剑兰saberC呆换人 7单 8大英雄

reboot_enable = 0
jump_dialog_enable = 1
Call boot
Sub boot //这里放一些只会初始化一次的变量
	Call fillParameter()
	//Call reboot_fgo
	Call system_run
End Sub
Sub system_run//重启的时候从这开始
	//TracePrint "system_run"
	//Call test()
	//Call script_failed()
	If only_fight = 1 Then
		Call fight()
    	Call after_fight() //战斗结算，回到主界面
    	Call stop_task()
	Else 
		
		For 1
		MoveTo 63, 92
		// Call testState()
    		ap_enought = 0
		
			Call saveColor() //要保证这里是在准备选择关卡的界面，会读取界面的颜色，用于结束时的判断
    		Call begin1() //选关卡
		
        		While ap_enought = 0
            		Call pall()
        			Call eat_apple()
        			If ap_enought = 0 Then 
        				log("ap not enought")
        				Delay wait_ap_enought
        			End If
				Wend
    		Call select_helper()
    		
			Call jump_dialog()
			//这边开始是打架的
			Call fight() //打架 以及打完架的检查
    		Call after_fight() //战斗结算，回到主界面
    		//Call fight_to_task()
    		Call go_mission_screen()
		Next
	
	End If//EndScript
	
End Sub
Sub pall()
	If select_dungeous = 0 Then
		Call p2()
	Else 
		Call p1()	
	End If
	
End Sub
//this func make mouse draw from tempP1 to tempP2
Sub movePage()
	tempP1x = 855
    tempP1y = 742 //p1 line4
    tempP2x = 855 
    tempP2y = 142//p2 line0
    Call mouseDraw
End Sub
Sub mouseDraw()
	Dim tempPx, tempPy
	Dim disx, disy,absx,absy
	Dim moveDis
	moveDis = 5
	tempPx = tempP1x
	tempPy = tempP1y
	MoveTo tempPx, tempPy
	LeftDown 1 //left down for draw

  Rem mouseLoop // do while
	//calculate distance
	If tempPx > tempP2x Then 
		absx = tempPx - tempP2x
		disx = -1 * moveDis // go -
	Else 
		absx = tempP2x - tempPx
		disx = 1 * moveDis // now is left,so go pluse
	End If
	If tempPy > tempP2y Then 
		absy = tempPy - tempP2y
		disy = - 1  * moveDis // now is up , so  go -
	Else 
		absy = tempP2y - tempPy
		disy = moveDis
	End If
	If (absx < (moveDis * 2)) AND (absy < (moveDis * 2)) Then //last point,draw and jump out
		tempPx = tempP2x
		tempPy = tempP2y
	Else 
		tempPx = tempPx + disx
		tempPy = tempPy + disy
	End If
	
	MoveTo tempPx, tempPy
	Delay 100 //draw 

	
	If (absx < (moveDis * 2)) AND (absy < (moveDis * 2)) Then //last point,draw and jump out
		Goto mouseLoopOut // jump out
	End If
	
  Goto mouseLoop // loop back
  Rem mouseLoopOut
	LeftUp 1 // leftup, draw end

    Delay 50	
	
End Sub
Sub p1()//这里几就选第几个本 1开始
Dim select_num
select_num = select_dungeous
	log_str = " select p1"
	//MoveTo 1123, 235
	Dim num_x_dungenous
	num_x_dungenous = 975//1123
	Call saveLog
    MoveTo 1221, 168
    LeftDoubleClick 1
                                    	Delay 2000
            LeftClick 1
                                     	Delay 2000
                                     
    If select_num = 5 Then //push up
    	tempP1x = num_x_dungenous
    	tempP1y = 401 //p1 line2
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    If select_num = 6 Then //push up
    	tempP1x = num_x_dungenous
    	tempP1y = 586 //p1 line3
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    If select_num = 7 Then //push up
    	tempP1x = num_x_dungenous
    	tempP1y = 742 //p1 line4
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    
    If select_num = 8 Then //push up
		Call movePage
    	tempP1x = num_x_dungenous
    	tempP1y = 401 //p1 line2
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    If select_num = 9 Then //push up
		Call movePage
    	tempP1x = num_x_dungenous
    	tempP1y = 586 //p1 line3
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    If select_num = 10 Then //push up
		Call movePage 
    	tempP1x = num_x_dungenous
    	tempP1y = 742 //p1 line4
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
        
    If select_num = 11 Then //push up
		Call movePage 
		Call movePage 
    	tempP1x = num_x_dungenous
    	tempP1y = 401 //p1 line2
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    
    If select_num = 12 Then //push up
		Call movePage 
		Call movePage 
    	tempP1x = num_x_dungenous
    	tempP1y = 586 //p1 line3
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    
    If select_num = 13 Then //push up
		Call movePage 
		Call movePage 
    	tempP1x = num_x_dungenous
    	tempP1y = 742 //p1 line4
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    
    If select_num = 14 Then //push up
		Call movePage 
		Call movePage 
		Call movePage 
    	tempP1x = num_x_dungenous
    	tempP1y = 401 //p1 line2
    	tempP2x = num_x_dungenous 
    	tempP2y = 142//p2 line0
    	Call mouseDraw
    End If
    
    If select_num = 1 Then
    	MoveTo num_x_dungenous, 239
    End If
    If select_num = 2 Then
    	MoveTo num_x_dungenous, 402
    End If
        
    If select_num = 3 Then
    	MoveTo num_x_dungenous, 612
    End If 
    If select_num >= 4 Then
        MoveTo num_x_dungenous, 727
	End If
    LeftClick 1
    Delay 500
    MoveTo 986, 225
    Delay 2500
End Sub
Sub p2()//选其他本打
//    MoveTo 1227, 154 //最上面
    MoveTo 1227, 158
LeftDoubleClick 1
                            	Delay 500
    MoveTo 1226, 603
    MoveTo 1226, 546
    MoveTo 1223, 508
        MoveTo 1230, 440
    MoveTo 1230, 420
//    MoveTo 1221, 389
//    MoveTo 1224, 359
        MoveTo 1225, 375 //5
//    MoveTo 1225, 395 //6
    MoveTo 1223, 561
    LeftDoubleClick 1
                                	Delay 500
 //   MoveTo 1228, 388
    LeftDoubleClick 1
                                    	Delay 500
    MoveTo 980, 246
    MoveTo 961, 204
//MoveTo 843, 589  //第二行
//MoveTo 1013, 446  //第一行
    LeftClick 1
                            	Delay 2000
End Sub
Sub p3()  //选第5个本打
    MoveTo 1227, 154
        LeftClick 1
                                	Delay 1500
    MoveTo 1219, 402
    LeftClick 1
                                	Delay 500
    MoveTo 997, 426
        LeftClick 1
                                	Delay 500
End Sub
Sub p4()  //选第5个本打
    MoveTo 896, 250
        LeftClick 1
                                	Delay 500
End Sub
Sub p5()  //选第5个本打
    MoveTo 1227, 154
        LeftClick 1
                                	Delay 500
    MoveTo 1224, 455
    LeftClick 1
                                	Delay 500
//    MoveTo 977, 487
    MoveTo 984, 251
//    MoveTo 861, 298
        LeftClick 1
                                	Delay 1000
End Sub

Dim skip_fight
Dim skill_used
Sub fight()
	Call fight_parm_init //初始化参数 如回合数等等
	log("sub fight start")
	While true//fight函数的死循环 满足skip fight的时候才能跳出
		//情况确认，满足打完的条件时跳出，否则接着打
		For 300 //300s 防止死等
        	skip_fight = 0//全局变量清零
        	Call check_fight_end()
        	If skip_fight = 1 Then 
				log (" condition good, fight end")
            	Goto mark3  //跳出
			End If
			//检查右下角是不是蓝色的，说明开始一个新的回合。
			tmp = wait_fight_attack_button_show(1000)//如果不是 等待1000s
			If tmp = 1 Then 
				MoveTo 1163, 100
				log ("start new fight turn")
				Delay (1000)
				tmp = wait_fight_attack_button_show(250)//如果不是 等待1000s
				If tmp = 1 Then 
					Goto mark1
				Else 
					TracePrint "attack button double check failed"
				End If
				
			End If
	
		Next
		log ("wait fight turn begin timeout:300s")
		Call script_failed //300s都卡着说明有问题 报错
		Rem mark1 //状态判断300s等待跳出 
		
		Call getBattleTurnState()//获得回合数 效果不好 
		Call setFightControl()//是否使用技能判断
		Call useSkill()   //用技能      
		Call useCostume()//用御主技能
        
        MoveTo 1101, 579 //点一下attack
    	LeftDoubleClick 1
		i=0
		For 50 //等待蓝色消失
		IfColor 1109,687,"C86502",2 Then
        		Delay 100
        		i = i + 1 //可能第一下没点到 再点一下
        		If i = 10 Then 
        			
        			i = 0
        			MoveTo 1101, 579 //点一下attack
    				LeftDoubleClick 1
        		End If
		Else
    		Goto mark2
		End If
		Next
		Rem mark2
		
		
		Delay 1500//等指令卡出现
		Call selectEnemy() 
		//Call setFightState() //修改宝具使用状态 //旧版的 二面三面才放宝具 
		
		Call selectEnemy()//先选个怪 免得宝具三连
		Call useHougu()
		Call selectEnemy()//选个怪 
	
		
	//    	Call redcard
    		Call bluecard
	// 下面是瞎点
		Call selectAllCard()
		Call trySelectItemInfoCloseButton()
	Wend
	
    Rem mark3 //跳出while
End Sub

Sub setFightState()
	houguReadyP1 = 1
	houguReadyP2 = 1
	houguReadyP3 = 1
	If battleState < 3 Then 
		houguReadyP2 = 0
	End If
	If battleState < 2 Then 
		houguReadyP1 = 0
	End If
End Sub

Sub bluecard()
Dim card_color(5)
    Dim i_card_color
IfColor 58,479,"F0F73",2 Then 
        card_color(0) = 1 
Else
    IfColor 1057, 479, "68260C", 2 Then
        card_color(0) = 2
    
                    			MoveTo 126, 537
//                    		Delay 1300
	Else
        card_color(0) = 3
	End If
End If
    IfColor 307,477,"F0F73",2 Then
        card_color(1) = 1 
Else
    IfColor 1057, 479, "68260C", 2 Then
        card_color(1) = 2 
                                            			MoveTo 126, 537
//                                		Delay 1300
	Else
        card_color(1) = 3
	End If
End If
    IfColor 556,478,"F0F73",2 Then
        card_color(2) = 1 
Else
    IfColor 1057, 479, "68260C", 2 Then
                    			MoveTo 630, 551
//                                            		Delay 1300
        card_color(2) = 2 
	Else
        card_color(2) = 3
	End If
End If
    IfColor 805,480,"F0F73",2 Then
        card_color(3) = 1 
Else
    IfColor 1057, 479, "68260C", 2 Then
        card_color(3) = 2 
//                                		MoveTo 805, 480
                                                        		Delay 1300
	Else
        card_color(3) = 3
	End If
End If
IfColor 1058,480,"F0F73",2 Then
        card_color(4) = 1 
Else
    IfColor 1057, 479, "68260C", 2 Then
        card_color(4) = 2 
                                		MoveTo 1058, 480
//                                                                    		Delay 1300
	Else
        card_color(4) = 3
	End If	
End If
    For 0
		If card_color(0) = 2 Then
        			MoveTo 126, 537
        		LeftClick 1
        		Delay 300
		End If
		If card_color(1) = 2 Then
            			MoveTo 388, 539
        		LeftClick 1
        		Delay 300
		End If
		If card_color(2) = 2 Then
        			MoveTo 630, 551
        		LeftClick 1
        		Delay 300
		End If
		If card_color(3) = 2 Then
                    		MoveTo 805, 480
        		LeftClick 1
        		Delay 300
		End If
		If card_color(4) = 2 Then
                    		MoveTo 1058, 480
        		LeftClick 1
        		Delay 300
		End If

        Next
If card_color(0) = 1 Then
        	MoveTo 126, 537
        LeftClick 1
        Delay 300
End If
If card_color(1) = 1 Then
            	MoveTo 388, 539
        LeftClick 1
        Delay 300
End If
If card_color(2) = 1 Then
        	MoveTo 630, 551
        LeftClick 1
        Delay 300
End If
If card_color(3) = 1 Then
                    MoveTo 805, 480
        LeftClick 1
        Delay 300
End If
If card_color(4) = 1 Then
                    MoveTo 1058, 480
        LeftClick 1
        Delay 300
End If
If card_color(0) > 1 Then
        	MoveTo 126, 537
        LeftClick 1
        Delay 300
End If
If card_color(1) > 1 Then
            	MoveTo 388, 539
        LeftClick 1
        Delay 300
End If
If card_color(2) > 1  Then
        	MoveTo 630, 551
        LeftClick 1
        Delay 300
End If
If card_color(3) > 1 Then
                    MoveTo 805, 480
        LeftClick 1
        Delay 300
End If
If card_color(4) > 1 Then
                    MoveTo 1058, 480
        LeftClick 1
        Delay 300
End If

End Sub

Sub redcard()
    IfColor 58,479,"F0F73",2 Then
    MoveTo 58, 479
        	LeftClick 1
        	Delay 200
Else
End If
    IfColor 307,477,"F0F73",2 Then
    MoveTo 307, 477
        	LeftClick 1
        	Delay 200
Else
End If
    IfColor 556,478,"F0F73",2 Then
    MoveTo 556, 478
        	LeftClick 1
        	Delay 200
Else
End If
    IfColor 805,480,"F0F73",2 Then
    MoveTo 805, 480
        	LeftClick 1
        	Delay 200
Else
End If
    IfColor 1058,480,"F0F73",2 Then
    MoveTo 1058, 480
        	LeftClick 1
        	Delay 200
Else
End If
End Sub
Sub skill()
//MoveTo 75, 615
//    MoveTo 148, 613
//    MoveTo 260, 619
//    MoveTo 388, 615
//    MoveTo 477, 621
//    MoveTo 557, 617
//    MoveTo 696, 619
//    MoveTo 780, 609
//    MoveTo 867, 615
    MoveTo 75, 615
    LeftClick 1
    Delay 3000
MoveTo 148, 613
LeftClick 1
Delay 3000
    MoveTo 260, 619
LeftClick 1
Delay 3000
    MoveTo 696, 619
LeftClick 1
Delay 3000
    MoveTo 780, 609
LeftClick 1
Delay 3000
End Sub
Sub skill1()
//MoveTo 75, 615
//    MoveTo 148, 613
//    MoveTo 260, 619
//    MoveTo 388, 615
//    MoveTo 477, 621
//    MoveTo 557, 617
//    MoveTo 696, 619
//    MoveTo 780, 609
//    MoveTo 867, 615
    MoveTo 75, 615
    LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
        LeftDoubleClick 1
    Delay 3000
MoveTo 148, 613
            LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
                LeftDoubleClick 1
Delay 3000
    MoveTo 260, 619
                    LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
                        LeftDoubleClick 1
Delay 3000
MoveTo 388, 615
                            LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
                                LeftDoubleClick 1
Delay 3000
MoveTo 477, 621
                                    LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
                                        LeftDoubleClick 1
Delay 3000
MoveTo 557, 617
                                            LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
                                                LeftDoubleClick 1
Delay 3000
    MoveTo 696, 619
                                                    LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
                                                        LeftDoubleClick 1
Delay 3000
    MoveTo 780, 609
                                                            LeftDoubleClick 1
        Delay 500
    MoveTo 637, 389
                                                                LeftDoubleClick 1
Delay 3000
        MoveTo 882, 615
                                                                LeftDoubleClick 1
            Delay 500
        MoveTo 637, 389
                                                                    LeftDoubleClick 1
    Delay 3000
End Sub
Sub begin1()
While true
                                                                    Goto mark5
        IfColor 1149,66,"B5FFFF",0 Then//IfColor 734,337,"D8E9F1",0 Then
        IfColor 149,724,"7EC0DC",2 Then
            MoveTo 1160, 76
                                                Goto mark5
Else
End If
Else
                    MoveTo 623, 679
                                                            Goto mark5
            IfColor 155,85,"DADADA",2 Then
            IfColor 1205,717,"DEDEDE",2 Then
                IfColor 1239,738,"EFB60D",2 Then
                                    MoveTo 1160, 76
                                                                    Goto mark5
Else
End If
Else
End If
Else
End If
End If
Wend
Rem mark5
End Sub

Sub eat_apple()
//    吃苹果
Dim apple_point_x(5)
Dim apple_point_y(5)
Dim apple_point_c(5)
	
	apple_point_x(0) = 359 //圣晶石
	apple_point_y(0) = 247
	apple_point_c(0) = "DE4379"//"D73A74"//"E24576"
	apple_point_x(1) = 387 //金
	apple_point_y(1) = 364
	apple_point_c(1) = "0991ce"//"0DCCFE"//"397D1"
	apple_point_x(2) = 384 //银
	apple_point_y(2) = 515
	apple_point_c(2) = "B2AD95"//"F1EFD9"//"C4BFA7"
	apple_point_x(3) = 990 //边栏
	apple_point_y(3) = 406
	apple_point_c(3) = "EDEDE5"//"F0F0F0"
//	apple_point_x(0) = 359 //圣晶石
//	apple_point_y(0) = 247
//	apple_point_c(0) = "E04475"//"E24576"
//	apple_point_x(1) = 387 //金
//	apple_point_y(1) = 364
//	apple_point_c(1) = "0598D1"//"397D1"
//	apple_point_x(2) = 384 //银
//	apple_point_y(2) = 515
//	apple_point_c(2) = "C3C1A8"//"C4BFA7"
//	apple_point_x(3) = 990 //边栏
//	apple_point_y(3) = 406
//	apple_point_c(3) = "F1E9E9"
	//Call print_color(apple_point_x,apple_point_y,apple_point_c,4)
	//TracePrint "eatapple"
	ap_enought = 1
	tmp = check_point_color(apple_point_x, apple_point_y, apple_point_c, 4)
	//t = print_color(apple_point_x, apple_point_y, apple_point_c, 4)
	If tmp = 1 Then 
		If need_apple <= 0 //满足吃苹果条件 不吃苹果 卡住
            	MoveTo 439, 400
                Delay 2000
                MoveTo 516, 654
                LeftClick 1
                Delay 1000
                //LeftClick 1
                ap_enought = 0
            	log ("not eat apple")
            		//TracePrint "not eat"
        Else 
            	log("eat apple")
                //MoveTo 439, 400
                MoveTo 439, 500//yin
                //MoveTo 439, 600//tong


                LeftDoubleClick 1
               	Delay 2000
                MoveTo 753, 613
//                	TracePrint "eatapple"
                LeftDoubleClick 1
               	Delay 1000
        		need_apple = need_apple - 1 
		End If
	End If
End Sub
Sub close_dialog()
	If jump_dialog_enable = 1 Then 
		MoveTo 1166, 86
		LeftClick 1
	
		Delay(1000)
		MoveTo 774, 603
		LeftClick 1
		Delay(1000)
	End If
	
End Sub
Sub jump_dialog()
	Dim jump_dialog_count
	jump_dialog_count = 0
	Rem mark_jump_dialog
	
	tmp = wait_fight_attack_button_show(3000)
	If tmp = 0 Then 
		jump_dialog_count = jump_dialog_count + 1
		If jump_dialog_count > 15 Then //循环5次 然后点击对话框 
			log("jump dialog")
			Call close_dialog()
		Else 
			Goto mark_jump_dialog
		End If
	End If
	
	log("jump dialog end")
	
End Sub
Sub select_helper()
//    选人
Dim helper_x(4), helper_y(4), helper_c(4)
	helper_x(0) = 62
	helper_y(0) = 99
	helper_c(0) = "D9D8D7"
	helper_x(1) = 915
	helper_y(1) = 87
	helper_c(1) = "E1D5C7"
	helper_x(2) = 1211
	helper_y(2) = 177
	helper_c(2) = "F1E9D1"
	helper_x(3) = 803
	helper_y(3) = 179
	helper_c(3) = "F8C702" 

    MoveTo 63, 92
    i=0
	While true
		IfColor 745,348,"F9E09E",2 Then
            Goto mark7
		End If
		IfColor 609,259,"FCF4EC",2 Then
            Goto mark7
		Else //防止没有指定礼装的人 
			tmp = check_point_color(helper_x, helper_y, helper_c, 4)
			If tmp = 0 Then //防止没进来 误触//20220107更新 损失了十几颗圣晶石
				
			Else 
				i = i + 1
				If i > 200 Then //20s
					MoveTo 838, 181
					LeftClick 1
					Delay 500
					MoveTo 763, 607
					LeftClick 1
					Delay 500
					i=0
	
				End If
			
			End If

            Delay 100
		End If
	Wend
	Rem mark7
    Delay 1000
	MoveTo 618, 340
	//Call mark_failed()
	LeftDoubleClick 1
    Delay 1000
	While true
    	IfColor 1153,685,"F0F0F0",2 Then
        	MoveTo 1153, 685
        	Delay wait_start_fight
        	LeftDoubleClick 1
            Goto mark6
		Else
        	MoveTo 63, 92
            Delay 100
		End If
	Wend
	Rem mark6
    //虚数海战适配
    Delay 5000
	MoveTo 880, 697
	LeftDoubleClick 1
    //虚数海战适配done
	
	MoveTo 1160, 76
	log("select help done")
End Sub
Sub after_fight() //从战斗结算 一直点击到屏幕变黑 
	log(" after fight")
//战斗结算
For 50
IfColor 1175,709,"D4D5D6",2 Then
            LeftDoubleClick 1
//    Goto mark4
Else
End If
        MoveTo 1175, 709
        LeftDoubleClick 1
    Delay 300
    	MoveTo 358, 613
        LeftDoubleClick 1

    Delay 300


        IfColor 1154,500,"0",0 Then
            IfColor 948,72,"0",0 Then
                IfColor 1221, 709, "0", 0 Then
                TracePrint "成功进入黑色界面"
                                            Goto mark4
Else
End If
Else
End If
Else
End If
Next

TracePrint "失败进入黑色界面"
    Rem mark4
End Sub


Sub fight_to_task()
	Dim fight_task_count
	Dim fight_task_time
	fight_task_count = 1
	fight_task_time = 0
	MoveTo 100, 347
	log(" fight_to_task")
    While (fight_task_count = 1 )
        fight_task_count = 0 
        IfColor 1115,714, "D6D6D6", 1 Then
    fight_task_count = 1 
	End If
    IfColor 151,93 ,"D7D6D5",1 Then
        fight_task_count = 1 
	Else
	End If
    IfColor 169,730,"5C99D6",1 Then
        fight_task_count = 1 
	Else
	End If 
	fight_task_time = fight_task_time + 1
        Delay 300
        MoveTo 380, 610 //to skip auto fight menu
        LeftClick 1

        IfColor 1208,707,"DEDEDD",0 Then
        IfColor 1177,713,"48271E",0 Then
            IfColor 1158,682,"F6B64B",0 Then
                IfColor 1235,682,"FDD437",0 Then
                    IfColor 1104,676,"F6AC1C",0 Then
                                fight_task_count = 0
		Else
		End If
		Else
		End If
		Else
		End If
		Else
		End If
		Else
		End If
	If fight_task_time = 180 Then
        	Goto mark8
	End If
Wend

    Rem mark8
        MoveTo 300, 347
End Sub
Sub stop_task()
	While (1 = 1)
	Delay 1000
	Wend
End Sub


//Dim kituna_point_x(5)
//Dim kituna_point_y(5)
//Dim kituna_point_col(5)

Sub fight_end_check_kitsuna()//检查羁绊等级是否到位
	

	Dim kitsunaOK
	
	kitsunaOK = 0
	log_str = " go check kituna"
	
	kitsunaOK = check_kituna_page() //20210831 add
	
	
//	IfColor 623,679,"FFFFFF",2 Then
//        	IfColor 87,232,"20B4E6",2 Then
//            	IfColor 102,231,"21BAE7",2 Then
//                	IfColor 536, 681, "FFFFFF", 2 Then 
//                    	skip_fight = 1
//					Else
//					End If
//				Else
//				End If
//			Else
//			End If
//	Else 
//	End If
			//检查战斗结束 
//    IfColor 87, 229, "26C2EC", 0 Then 
//        IfColor 126,469,"9A3C13",0 Then
//            IfColor 156,472,"003000",0 Then
//            	IfColor 655,473,"0CEDFE",0 Then 
//					kitsunaOK = 1
//					log_str = " check kitsuna 1 ok"
//					Call saveLog
//				End If 
//			End If 
//		End If 
//	End If
//	IfColor 83, 226, "31CEFA", 0 Then
//		IfColor 125, 473, "C76924", 0 Then
//			IfColor 340, 470, "D09750", 0 Then
//				IfColor 559, 475, "640600", 0 Then
//					kitsunaOK = 1 
//					log_str = " check kitsuna 2 ok"
//				End If  
//			End If  
//		End If  
//	End If
//	IfColor 127,474,"8A2C0B",0 Then
//    	IfColor 158,474,"216014",0 Then
//        	IfColor 194,473,"57FFB0",0 Then
//            	IfColor 225, 475, "2FDFE", 0 Then
//            			kitsunaOK = 1 
//						log_str = " check kitsuna 3 ok"
//		
//				End If
//			End If
//		End If
//	End If
//	
//	IfColor 82, 231, "24BFEC", 0 Then
//		IfColor 125, 478, "740000", 0 Then
//			IfColor 158, 474, "63AC41", 0 Then
//				IfColor 191, 479, "BF95E", 0 Then
//				
//            						kitsunaOK = 1 
//									log_str = " check kitsuna 4 ok first one have kituna 3"
//				End If
//			End If
//		End If
//	End If

	Call saveLog
	log_str = " fight_end_check_kitsuna"
	Call saveLog
	If kitsunaOK = 1 Then  //确认完毕 点击两下 进入下个页面 
		log_str = " kitsunaOK,here skip fight"
		Call saveLog
        MoveTo 521, 354                      
        Delay 2000
		MoveTo 521, 354
        LeftDoubleClick 1
        Delay 2000
        skip_fight = 1 
	End If
End Sub

Sub item_selected()
	Dim double_check_select
	double_check_select = 0

	log_str = " item select"
	Call saveLog
	If double_check_select = 0 Then 
		//IfColor 548, 609, "D3D3D3", 0 Then
    		IfColor 990,712,"D4D4D3",0 Then
            	IfColor 1126, 711, "C5B5AB", 0 Then			
					log_str = " item get once"
					Call saveLog	
            		double_check_select = 1
            		Delay 4000 //等5s 看看是不是闪了一下 
				Else
				End If
 	
			Else
			End If	
		//Else 
		//End If
	End If
    
	If double_check_select = 0 Then 
	    IfColor  694,608,"D7D7D7",0 Then
    		IfColor 1032,135,"E09E0F",0 Then
            	IfColor 987, 717, "D6D7D8", 0 Then
            		log_str = " item get once1"
					Call saveLog
            		double_check_select = 1
            		Delay 4000 //等5s 看看是不是闪了一下 
				Else
				End If
 	
			Else
			End If
		Else
		End If
	End If
	
	If double_check_select = 0 Then 
	    
    //    IfColor 122,138,"24BCEE",0 Then
    //    	IfColor 1029,135,"E3A80B",0 Then
            	IfColor 966, 712, "D1D1D1", 0 Then
            	
            		log_str = " item get once2"
					Call saveLog
            		double_check_select = 1
            		Delay 4000 //等5s 看看是不是闪了一下 
	
				End If
	//		End If
	//	End If
				
	End If
//-- 
	If double_check_select = 1 Then 
			log("item get once2")
    //	IfColor  548,609,"D3D3D3",0 Then
    		IfColor 990,712,"D4D4D3",0 Then
            	IfColor 1126,711,"C5B5AB", 0 Then 
                  		MoveTo 258, 204//执行点到的动作
						Delay 1000
                    	MoveTo 558, 604
                    	LeftClick 1
                        skip_fight = 1
                        double_check_select = 0 
				Else
				End If
 	
			Else
			End If
	//	Else  
	//	End If
	End If
	If double_check_select = 1 Then 
		IfColor  694,608,"D7D7D7",0 Then
    		IfColor 1032,135,"E09E0F",0 Then
            	IfColor 987,717,"D6D7D8", 0 Then
                  		MoveTo 258, 204
						Delay 1000
                    	MoveTo 558, 604
                    	LeftClick 1
                        skip_fight = 1
                        double_check_select = 0 
				Else
				End If
 		
			Else
			End If
		Else
		End If	
	End If
	If double_check_select = 1 Then 
	    
        IfColor 122,138,"24BCEE",0 Then
        	IfColor 1029,135,"E3A80B",0 Then
            	IfColor 966, 712, "D1D1D1", 0 Then
                  		MoveTo 258, 204
						Delay 1000
                    	MoveTo 558, 604
                    	LeftClick 1
                        skip_fight = 1
                        double_check_select = 0 
				End If
			End If
		End If
				
	End If
	If skip_fight = 1 Then 
		log("item_selected first skip")
	End If
End Sub
Dim battleState
Dim lastBattleState
Sub getBattleTurnState()
	lastBattleState = battleState
    		battleState = 0
IfColor 855,66,"F4F4F4",0 Then
    IfColor 855,80,"EFEFEF",0 Then
        IfColor 851,69,"BABABA",0 Then
		battleState = 1
Else
End If
Else
End If
Else
End If
    IfColor 856,70,"F0F0F0",0 Then
    IfColor 848,81,"DCDCDC",0 Then
        IfColor 855,81,"C5C5C5",0 Then
            		battleState = 2
Else
End If
Else
End If
Else
End If
    IfColor 846,68,"A6A6A6",0 Then
    IfColor 850,73,"B1B1B1",0 Then
        IfColor 847,80,"BCBCBC",0 Then
            		battleState = 3
Else
End If
Else
End If
Else
End If
End Sub

Sub testState()
	//Call hunmanChange()
//	Call getSkillDefaultColor()
	While (1)
//		Call checkSkillState()
//		Call getBattleTurnState()
//		If battleState = 0 Then 
//            MoveTo 82, 123
//		End If
//		If battleState = 1 Then 
//            MoveTo 1173, 123
//		End If
//		If battleState = 2 Then 
//        MoveTo 36, 714
//		End If
//		If battleState = 3 Then 
//        MoveTo 1220, 734
//		End If
//		
		Delay(1000)
	Wend
End Sub

Sub hunmanChange()
		Delay 50
	If changeMember1 > 0   Then 
		Else 
		Goto MarkChangeMember
	End If
	MoveTo 1165, 353
	Delay 50
	LeftClick 1
	Delay 200
	MoveTo 1062, 361
	Delay 50
	LeftClick 1
	Delay 500
	//切出换人界面
	If changeMember1 = 3 Then 
		MoveTo 528, 403
		Delay 50
		LeftClick 1
	ElseIf changeMember1 = 2 Then
		MoveTo 308, 392
		Delay 50
		LeftClick 1
	Else 
		MoveTo 147, 381
		Delay 50
		LeftClick 1
	End If	
	Delay 50
	
	If changeMember1 = 3 Then 
		MoveTo 1108, 333
		Delay 50
		LeftClick 1
	ElseIf changeMember1 = 2 Then
		MoveTo 931, 393
		Delay 50
		LeftClick 1
	Else 
		MoveTo 734, 385
		Delay 50
		LeftClick 1
	End If
	//确认
	MoveTo 632, 651
	Delay 50
	LeftClick 1
	Delay 50
	MoveTo 1220, 183//点下x保险
	LeftClick 1
	Delay 5000 //换人时间
	Rem MarkChangeMember

End Sub
Sub useHougu()

	Call selectEnemy() 
	Call useHouguP1()
	
	Call selectEnemy() 
	Call useHouguP2()
	Call useHouguP3()
End Sub
Sub useHouguP1()
	If houguReadyP1 > 0 Then 
		Call useHouguRootP1()
	End If
End Sub
Sub useHouguP2()
	If houguReadyP2 > 0 Then 
		Call useHouguRootP2()
	End If
End Sub
Sub useHouguP3()
	If houguReadyP3 > 0 Then 
		Call useHouguRootP3()
	End If
End Sub
Sub useHouguRootP1()
        MoveTo 393, 232
    	LeftClick 1
    	Delay 250
End Sub
Sub useHouguRootP2()
   		MoveTo 631, 250
    	LeftClick 1
    	Delay 250
End Sub
Sub useHouguRootP3()
	    MoveTo 857, 262
    	LeftClick 1
    	Delay 350
End Sub

Sub selectEnemy()
		If target_person = 1 Then 
            MoveTo 150, 91
        End If
        If target_person = 2 Then
            MoveTo 290, 91
        End If
        If target_person = 3 Then
            //MoveTo 450, 91
            MoveTo 550, 91
		End If
        Delay 50
        LeftDoubleClick 1
        Delay 100
End Sub
Sub trySelectItemInfoCloseButton()
	Delay 50
	MoveTo 636, 574
	LeftClick 1
	Delay 50
	MoveTo 634, 606
	LeftClick 1
	Delay 50
	MoveTo 627, 629
	LeftClick 1
	Delay 50
	MoveTo 627, 652
	LeftClick 1
	Delay 50
	MoveTo 629, 679
	LeftClick 1
	Delay 50
	MoveTo 27, 424 // this line for select any other place
	LeftClick 1
	Delay 50

End Sub
Sub selectAllCard()
	//MoveTo 1058, 480
	MoveTo 1058, 295 //三个宝具位置
	LeftClick 1
	Delay 200
	Call selectEnemy() //如果没有宝具卡 实际上会点个怪 会有问题
    MoveTo 805, 295//480
	LeftClick 1
	Delay 200
	Call selectEnemy() //如果没有宝具卡 实际上会点个怪 会有问题
	MoveTo 630, 295//551
	LeftClick 1
	Delay 200
	Call selectEnemy() //点指令卡之前先把目标点了
    
    MoveTo 388, 295//539
    LeftClick 1
    Delay 200
    MoveTo 126, 295//537
    LeftClick 1
    Delay 200
    MoveTo 1058, 295//480
	LeftClick 1
	Delay 200
    MoveTo 805, 295//480
	LeftClick 1
	Delay 200
	MoveTo 630, 295//551
	LeftClick 1
	Delay 200

    MoveTo 388, 295//539
    LeftClick 1
    Delay 200
    MoveTo 126, 295//537
    LeftClick 1
    //skillDefaultPosX
    Delay 200
End Sub


Sub fight_parm_init
	fight_turn = 0
	skill_used = 0
	houguReadyP1 = 0
	houguReadyP2 = 0
	houguReadyP3 = 0
	If fight_plan = 0 Then 
		Call fight_parm_default
		log("fight plan default")
	ElseIf fight_plan = 1 Then
		Call fight_parm_redA
	ElseIf fight_plan = 2 Then
		Call fight_parm_mutuki_lilith//这个是c呆枪莉莉丝c呆冲浪的
	ElseIf fight_plan = 3 Then
		Call fight_parm_rong//这个是c呆枪阿荣c呆冲浪的
	ElseIf fight_plan = 4 Then
		Call fight_parm_sige_change//这个是美狄亚双c呆换人
	ElseIf fight_plan = 5 Then
		Call fight_parm_tmp
	ElseIf fight_plan = 6 Then
		Call fight_parm_saber//saber剑兰
	ElseIf fight_plan = 7 Then
		Call fight_parm_sige_single//50初始np的齐格
	ElseIf fight_plan = 8 Then
		Call fight_parm_stella//50初始np的齐格
	End If
	
End Sub
Sub getSkillDefaultColor()
	Dim i
	i = 0
	For 9
		skillDefaultColor(i) = GetPixelColor(skillDefaultPosX(i),skillDefaultPosY)
		i = i + 1
	Next 

End Sub
Sub setFightControl()//实现技能和宝具释放的逻辑
//    Dim i
//	skillUseable = Array(0,0,0,0,0,0,0,0,0)
//	If skill_used < 1 Then
//        
//        i = 0
//        For 9
//        	skillUseable(i) = 1
//        	i=i+1
//        Next
//		skill_used = 1
//	End If
//    skill_used = skill_used + 1
//    If skill_used > 9  Then //9 turn 归0 
//   		skill_used = 0
//    End If
    //这块要实现三方面的内容
//    1 宝具的控制
//    2 御主服装的控制
//    3 技能的控制
//    4 战斗对象控制 
//    实现上说 我们只管前面5个回合的剧本，5个回合打不完就用之前xjb打的方法
//    1 宝具
//    定义一个数组 里面是每个从者第一个放宝具的回合 回合从1开始计数 0做另外用途
//    2 御主服装
//    默认换人服装 定义技能的使用回合数，只放一次 默认换人服 换3号和4号位 请将三号位的数值，按照4号位的标准来设置。先换人后使用技能 换完人将三号位的cd清零即可，默认释放技能的回合仍然按照三号位的来，cd写四号位的 
//    3 技能
//    技能定义最初释放的回合以及cd cd到后再次释放。
//    4 战斗对象 设置一个5turn的数组 控制打哪一个敌人 大于5就不管了
//
//    对于战斗逻辑，预先设置很多个模板，然后根据参数去调这些模板
	
    log ("new turn fight control")
    If fight_turn = 0 Then 
    	log ("now turn is 0")
    End If
    i = 0
    //战斗服
    For 3
    
    	log("costume_use set 0")
    	costume_use(i) = 0
    	If (costume_eb(i) = fight_turn) Then 
    		log("costume_use now")
    		costume_use(i) = 1
    	End If
    	i=i+1
    Next
    If costume_order_change = 1 Then //当前回合使用换人服
    	If (costume_use(2)=1) Then
    		skill_eb_turn(6) = fight_turn
    		skill_eb_turn(7) = fight_turn
    		skill_eb_turn(8) = fight_turn //换完人放技能 
    	
    	End If
    End If
    //技能控制 
    i = 0
    For 9 
    	skillUseable(i) = 0
    	If (skill_eb_turn(i) <= fight_turn)  Then 
    		skill_eb_turn(i) = skill_eb_turn(i) + skill_cd(i)//下一次在cd转好的时候跑
    		skillUseable(i) = 1//本轮开技能 
    	End If
    	i = i+1
    Next
    
    //战斗对象
    If fight_turn < 9 Then 
    	target_person = fight_target(fight_turn)
    End If
    //宝具
    If hougu_eb_turn(0) <= fight_turn Then 
    	houguReadyP1 = 1
    End If
    If hougu_eb_turn(1) <= fight_turn Then 
    	houguReadyP2 = 1
    End If
    If hougu_eb_turn(2) <= fight_turn Then 
    	houguReadyP3 = 1
    End If
    
	fight_turn = fight_turn +1 //turn 加1 
   
    
End Sub
Sub checkSkillState()
	Dim i
	Dim tempColor
	i = 0
	For 9
		tempColor = GetPixelColor(skillDefaultPosX(i), skillDefaultPosY)
		If tempColor = skillDefaultColor Then 
			skillState(i) = 1
		Else 
			skillState(i) = 0
		End If
		i = i+1
	Next
	If skillState(0) = 1 Then 
		MoveTo 153, 121

		Else 
		MoveTo 1230, 118

	End If
End Sub

Sub useCostume()
	Dim i
	i = 0
	For 3
		If costume_use(i) = 1 Then 
			log ("use costume")//temp
			MoveTo 865, 106 //点一下旁边 随便一下点击可能误认为取消
			LeftClick 1
        	Delay 100
        	
			If costume_order_change = 1 Then 
			
				log ("order change")//temp
        		
				MoveTo costumePosX(0), costumePosY(0) //点开菜单
				LeftClick 1
        		Delay 500
    			MoveTo costumePosX(i+1), costumePosY(i+1) //+1是因为0是点菜单的点位置
        		LeftClick 1
        		
        		Delay 200
        		
        			
				If i=2 Then //换人服 
					MoveTo costumePosX(4), costumePosY(4) //选3号位
					LeftClick 1
        			Delay 200
					MoveTo costumePosX(5), costumePosY(5) //选4号位
					LeftClick 1
        			Delay 200
					MoveTo costumePosX(6), costumePosY(6) //选4号位
					Delay 200
					
					LeftClick 1
					If skill_double = 1 Then 
						Delay 1000 //do twith
						
						MoveTo costumePosX(0), costumePosY(0) //点开菜单
						LeftClick 1
        				Delay 500
    					MoveTo costumePosX(i+1), costumePosY(i+1) //+1是因为0是点菜单的点位置
        				LeftClick 1
        				
        				Delay 200
        				
						MoveTo costumePosX(4), costumePosY(4) //选3号位
						LeftClick 1
        				Delay 200
						MoveTo costumePosX(5), costumePosY(5) //选4号位
						LeftClick 1
        				Delay 200
						MoveTo costumePosX(6), costumePosY(6) //选4号位
						Delay 200
						
						LeftClick 1
								
						tmp = wait_fight_attack_button_show(15000)//换人可能网络会卡 等久一点 
						Call useSkillP3() //here use person3 skill
					End If
				End If
				tmp = wait_fight_attack_button_show(2500) 

			Else //其他衣服选中间的按钮 
				log ("normal costume")
				
				MoveTo costumePosX(0), costumePosY(0) //点开菜单
				LeftClick 1
        		Delay 500
    			MoveTo costumePosX(i+1), costumePosY(i+1) //+1是因为0是点菜单的点位置
        		LeftClick 1
        		Delay 500
        		MoveTo costumePosX(7), costumePosY(7) //选4号位
				LeftClick 1
			End If
			
        	MoveTo 624, 389
    		tmp = wait_fight_attack_button_show(2500)
		End If
		
		i = i+1
	Next
End Sub

Sub useSkillP3()
	Dim i
	i = 6//6 7 8 
	For 3
		If skillUseable(i) Then 
			MoveTo 844, 95
			LeftDoubleClick 1 //把框点掉
			Delay 200
			MoveTo skillDefaultPosX(i), skillDefaultPosY
			LeftClick 1
        	Delay 300
    		MoveTo 624, 389
    		
        	LeftDoubleClick 1
    		tmp = wait_fight_attack_button_show(2500)
    		If skill_double = 1 Then 
					
				MoveTo 844, 95
				LeftDoubleClick 1 //把框点掉
				Delay 200
				MoveTo skillDefaultPosX(i), skillDefaultPosY
				LeftClick 1
        		Delay 300
    			MoveTo 624, 389
    			
        		LeftDoubleClick 1
    			tmp = wait_fight_attack_button_show(2500)
				
			End If
		End If
		i = i+1
	Next
	
    Delay 100
	MoveTo 844, 95
	LeftDoubleClick 1//把框点掉

End Sub
Sub useSkill()
	Dim skillPersonX(3), skillPersonY
	Dim i
	i = 0
	skillPersonX(0) = 405
	skillPersonX(1) = 618
	skillPersonX(2) = 817
	skillPersonY = 380//432

	For 9
		If skillUseable(i) Then 
			MoveTo 844, 95
			LeftDoubleClick 1 //把框点掉
			Delay 200
			MoveTo skillDefaultPosX(i), skillDefaultPosY
			LeftClick 1
        	Delay 300
    		MoveTo skillPersonX(skill_person(i)),skillPersonY
    		//MoveTo 624, 389
    		
        	LeftDoubleClick 1
    		tmp = wait_fight_attack_button_show(2500)
    		If skill_double = 1 Then 
					
				MoveTo 844, 95
				LeftDoubleClick 1 //把框点掉
				Delay 200
				MoveTo skillDefaultPosX(i), skillDefaultPosY
				LeftClick 1
        		Delay 300
    			//MoveTo 624, 389
    			MoveTo skillPersonX(skill_person(i)),skillPersonY
    			
        		LeftDoubleClick 1
    			tmp = wait_fight_attack_button_show(2500)
				
			End If
		End If
		i = i+1
	Next
	
    Delay 100
	MoveTo 844, 95
	LeftDoubleClick 1//把框点掉
End Sub
	
Sub fillParameter()
	i = 0
	tmp = 0
	changeMember1 = 2
	changeMember2 = 2
	skillDefaultPosY = 588
	skillDefaultPosX = Array(48, 141, 232, 359, 452, 544, 675, 762, 859, 1220)
	skill_double = 0
	target_person = 1
	costumePosX = Array(1155,881,976,1038,538,703,631,624)
	costumePosY = Array(353, 347,347, 347,388,392,671,401)
	//这几个点分别是 0 战斗服菜单点开 1 菜单第一个点 2 菜单第二个点 3 菜单第三个点 4 换人服3号位 5换人服4号位 6 中间的人的位置 7 确定 8非换人服点中间人
	timeout = 0
	timeout_limit = 300
End Sub

Sub debugStop0
	While true
		Delay 500
		MoveTo 46, 90
	Wend
End Sub
Sub debugStop1
	While true
		Delay 500
		MoveTo 1182, 70
	Wend
End Sub
Sub debugStop2
	While true
		Delay 500
		MoveTo 81, 714	
	Wend
End Sub
Sub debugStop3
	While true
		Delay 500
		MoveTo 1161, 687
	Wend
End Sub
Sub saveLog
	Call Plugin.File.WriteFileEx("D:\\log.txt", Time & log_str)
End Sub

//20210831 update


Function log(str)
	log_str = str
	Call Plugin.File.WriteFileEx("D:\\log.txt", Time & log_str)
End Function



Function log_val(str)
	Call Plugin.File.WriteFileEx("D:\\log.txt", Time & str)
End Function

Sub check_fight_end //确认打完架相关的函数 
	log("start check fight status")
	Call item_selected()
	Call fight_end_check_kitsuna()
	//Call is_item_showing()
End Sub

Function check_kituna_page() //打完架羁绊结算界面，确认状态
	Dim kituna_point_x(5)
	Dim kituna_point_y(5)
	Dim kituna_point_c(5)
	
	kituna_point_x(0) = 85 //左上角第一个小箭头
	kituna_point_y(0) = 231
	kituna_point_c(0) = "22BEE8"
	kituna_point_x(1) = 100 //左上角第二个小箭头
	kituna_point_y(1) = 237
	kituna_point_c(1) = "16AAE3"
	kituna_point_x(2) = 130 //第一个人的第1个羁绊星星
	kituna_point_y(2) = 476
	kituna_point_c(2) = "760C03"
	kituna_point_x(3) = 161 //第一个人的第2个羁绊星星
	kituna_point_y(3) = 474
	kituna_point_c(3) = "5AAE3B"
	kituna_point_x(4) = 192 //第一个人的第3个羁绊星星
	kituna_point_y(4) = 476
	kituna_point_c(4) = "ABD4D"

	tmp = check_point_color_half(kituna_point_x, kituna_point_y, kituna_point_c, 5)
	check_kituna_page = 0
	If tmp = 0 Then 

	Else 
		log("check kituna first ok")
		check_kituna_page = 1
		Delay(2000)
		tmp = check_point_color_half(kituna_point_x, kituna_point_y, kituna_point_c, 5)
		If tmp = 0 Then 
			MoveTo 264, 233

			LeftClick 1
			tmp = check_point_color_half(kituna_point_x, kituna_point_y, kituna_point_c, 5)
			Delay(800)
			If tmp = 0 Then 
				check_kituna_page = 0
				log("check kituna twice failed")
			
			End If
		End If
	End If



End Function
//
//Function check_kituna_page() //打完架羁绊结算界面，确认状态
//	Dim kituna_point_x(20)
//	Dim kituna_point_y(20)
//	Dim kituna_point_c(20)
//	
//	kituna_point_x(0) = 85 //左上角第一个小箭头
//	kituna_point_y(0) = 231
//	kituna_point_c(0) = "22BEE8"
//	kituna_point_x(1) = 100 //左上角第二个小箭头
//	kituna_point_y(1) = 237
//	kituna_point_c(1) = "16AAE3"
//	kituna_point_x(2) = 130 //第一个人的第1个羁绊星星
//	kituna_point_y(2) = 476
//	kituna_point_c(2) = "760C03"
//	kituna_point_x(3) = 161 //第一个人的第2个羁绊星星
//	kituna_point_y(3) = 474
//	kituna_point_c(3) = "5AAE3B"
//	kituna_point_x(4) = 192 //第一个人的第3个羁绊星星
//	kituna_point_y(4) = 476
//	kituna_point_c(4) = "ABD4D"
//	kituna_point_x(5) = 993 //第五个人的第1个羁绊星星
//	kituna_point_y(5) = 477
//	kituna_point_c(5) = "7E0F04"
//	kituna_point_x(6) = 1025 //第五个人的第2个羁绊星星
//	kituna_point_y(6) = 472
//	kituna_point_c(6) = "82D06E"
//	kituna_point_x(7) = 1051 //第五个人的第3个羁绊星星
//	kituna_point_y(7) = 478
//	kituna_point_c(7) = "49E15"
//	kituna_point_x(8) = 777 //第四个人的第1个羁绊星星
//	kituna_point_y(8) = 474
//	kituna_point_c(8) = "C4702A"
//	kituna_point_x(9) = 811 //第四个人的第2个羁绊星星
//	kituna_point_y(9) = 480
//	kituna_point_c(9) = "14750C"
//	kituna_point_x(10) = 839 //第四个人的第3个羁绊星星
//	kituna_point_y(10) = 479
//	kituna_point_c(10) = "AF152"
//
//	kituna_point_x(11) = 134 //第1个人的11羁绊星星中
//	kituna_point_y(11) = 493
//	kituna_point_c(11) = "B7A93F"
//	kituna_point_x(12) = 133 //第1个人的11羁绊星星上
//	kituna_point_y(12) = 477
//	kituna_point_c(12) = "7AE7EC"
//	kituna_point_x(13) = 146 //第1个人的11羁绊星星右
//	kituna_point_y(13) = 491
//	kituna_point_c(13) = "B39605"
//	kituna_point_x(14) = 131 //第1个人的11羁绊星星下
//	kituna_point_y(14) = 506
//	kituna_point_c(14) = "D6BCD3"
//
//	kituna_point_x(15) = 780 //第4个人的11羁绊星星中
//	kituna_point_y(15) = 491
//	kituna_point_c(15) = "83EED4"
//	kituna_point_x(16) = 781 //第4个人的11羁绊星星上
//	kituna_point_y(16) = 478
//	kituna_point_c(16) = "87F4F7"
//	kituna_point_x(17) = 796 //第4个人的11羁绊星星右
//	kituna_point_y(17) = 493
//	kituna_point_c(17) = "E8BA57"
//	kituna_point_x(18) = 781 //第4个人的11羁绊星星下
//	kituna_point_y(18) = 506
//	kituna_point_c(18) = "D5BDD8"
//
//	tmp = check_point_color_half(kituna_point_x, kituna_point_y, kituna_point_c, 19)
//	check_kituna_page = 0
//	If tmp = 0 Then 
//
//	Else 
//		log("check kituna first ok")
//		check_kituna_page = 1
//		Delay(2000)
//		tmp = check_point_color_half(kituna_point_x, kituna_point_y, kituna_point_c, 19)
//		If tmp = 0 Then 
//			MoveTo 264, 233
//
//			LeftClick 1
//			tmp = check_point_color_half(kituna_point_x, kituna_point_y, kituna_point_c, 19)
//			Delay(800)
//			If tmp = 0 Then 
//				check_kituna_page = 0
//				log("check kituna twice failed")
//			
//			End If
//		End If
//	End If
//
//
//
//End Function

Sub is_item_showing()//打完架战利品界面 确认下状态
	Dim prize_view_x(4) //战利品界面 找4个点
	Dim prize_view_y(4)
	Dim prize_view_c(4)
	prize_view_x(0) = 121 //左上角的两个箭头
	prize_view_y(0) = 140
	prize_view_c(0) = "141414"
	prize_view_x(1) = 140
	prize_view_y(1) = 140
	prize_view_c(1) = "141414"
	prize_view_x(2) = 1027 //右上角切换显示的图标
	prize_view_y(2) = 135
	prize_view_c(2) = "85B6CC"
	prize_view_x(3) = 967 //右下角确认键白色
	prize_view_y(3) = 712
	prize_view_c(3) = "505050"

	
	tmp = check_point_color(prize_view_x,prize_view_y,prize_view_c,4)
	If tmp = 1 Then 
		log("item showing")
		skip_fight = 1
	End If
End Sub

Sub go_mission_screen
	//注意 选择关卡的时候有个全屏的滤镜，会导致像素点有微妙的不同
	//因此种火任务要自己一套的桌面检测，这个没有什么好办法。



	Dim go_mission_screen_count
	go_mission_screen_count = 0
	log("back to  mission screen 60s")
	For 300
		tmp = check_point_color(mission_screen_x,mission_screen_y,mission_screen_c,5)
		If tmp = 1 Then 
			log("back success,jump")
			Goto go_mission_screen_end
		End If
		Delay (200)
		MoveTo mission_screen_x(5), mission_screen_y(5)
		LeftClick 1
		
		go_mission_screen_count = go_mission_screen_count + 1
		If go_mission_screen_count = 100 Then 
			log("try close dialog")
			Call close_dialog()
		End If
	Next
	tmp = print_color(mission_screen_x,mission_screen_y,mission_screen_c,5)
	log("back to mission screen timeout")
	Call script_failed
	Rem go_mission_screen_end
	

End Sub


Function check_point_color(x, y, col, size)
	Dim color_status
	Dim i_check_point_color
	i_cpclr = 0
	color_status = 1

	For size
		IfColor x(i_cpclr),y(i_cpclr),col(i_cpclr),2 Then
		// 颜色相同 啥都不做
		Else 
		// 颜色不同 变量设置为0
		color_status = 0
		End If
		i_cpclr = i_cpclr + 1
	Next

	check_point_color = color_status
End Function

Function check_point_color_half(x, y, col, size)
	
	Dim color_status
	Dim i_check_point_color
	i_cpclr = 0
	color_status = 0

	For size
		IfColor x(i_cpclr),y(i_cpclr),col(i_cpclr),2 Then
		// 颜色相同 自增1
			color_status = color_status +1 
		Else 
		// 颜色不同 变量设置为0
		
		End If
		i_cpclr = i_cpclr + 1
	Next
	color_status = color_status * 4//只要求1/4
	If color_status > size Then 
		check_point_color_half = color_status
	Else 
		check_point_color_half = 0
	End If
	
End Function

Function check_point_color_single(x, y, col, channel)
	Dim color_status
	Dim i_check_point_color
	i_cpclr = channel
	color_status = 1

		IfColor x(i_cpclr),y(i_cpclr),col(i_cpclr),0 Then
		// 颜色相同 啥都不做
		Else 
		// 颜色不同 变量设置为0
		color_status = 0
		End If
	
	check_point_color_single = color_status
End Function

Function check_station() //0 错误 1 公告栏 2 活动界面 开始时自动保存的
	Dim station_public_notice_x(4)
	Dim station_public_notice_y(4)
	Dim station_public_notice_c(4)
	
	station_public_notice_x(0) = 68
	station_public_notice_y(0) = 80
	station_public_notice_c(0) = "151D1D"
	station_public_notice_x(1) = 1190
	station_public_notice_y(1) = 85
	station_public_notice_c(1) = "33230A"
	station_public_notice_x(2) = 223
	station_public_notice_y(2) = 592
	station_public_notice_c(2) = "6D3302"
	station_public_notice_x(3) = 1071
	station_public_notice_y(3) = 585
	station_public_notice_c(3) = "E5E5E5"
	tmp = check_point_color(station_public_notice_x, station_public_notice_y, station_public_notice_c, 4)
	check_station = 0
	If tmp = 1 Then 
		check_station = 1
		Goto mark_check_station_end
	End If
	
	tmp = check_point_color(mission_screen_x,mission_screen_y,mission_screen_c,5)
	If tmp = 1 Then 
		check_station = 2
		Goto mark_check_station_end
	End If
	
	
	Rem mark_check_station_end

	
End Function

Function wait_fight_attack_button_show(timeout)//这个同样可能存在各个场景色调不一样的问题 
	Dim fight_attack_x(2) //打架界面 右下角攻击键
	Dim fight_attack_y(2) //打架界面 右下角攻击键
	Dim fight_attack_c(2)//打架界面 右下角攻击键
	//fight_attack_button_x(0) = 1210
	//fight_attack_button_x(1) = 1104
	fight_attack_x(0) = 1107
	fight_attack_y(0) = 589
	fight_attack_c(0) = "F9E902"
	fight_attack_x(1) = 1164
	fight_attack_y(1) = 318
	fight_attack_c(1) = "3E261D"
	
//	GetColor=GetPixelColor(1107,589)
//	TracePrint GetColor
//	GetColor=GetPixelColor(1164,318)
//	TracePrint GetColor

	tmp = wait_point_color_timeout(timeout,fight_attack_x,fight_attack_y,fight_attack_c,2) //function必须要有个返回值
	
	wait_fight_attack_button_show = tmp
End Function


Function wait_point_color_timeout(timeout, x, y, col, size)
	Dim timeout_div
	Dim wait_point_color_timeout_ret
	timeout_div = timeout / 250//250ms判断一次
	wait_point_color_timeout_ret = 0
	For timeout_div
		tmp = check_point_color(x, y, col, size)
		If tmp = 1 Then 
			wait_point_color_timeout_ret = 1
			Goto wait_point_color_timeout_break
		End If
		Delay (250)
	Next
	Rem wait_point_color_timeout_break
	wait_point_color_timeout = wait_point_color_timeout_ret
End Function

Sub fight_parm_default
	skill_double = 0
	i = 0
	For 9
		skill_cd(i) = 9
		skill_eb_turn(i) = 0
		skill_person(i) = 1
		fight_target(i) = target_person //1 2 3 没有0
		i = i+1
	Next
	i = 0
	For 3
		costume_eb(i)=99 //默认不用
		hougu_eb_turn(i) = 0
		i = i+1
	Next
	
	costume_eb(2) = 3
	costume_eb(1) = 2
	costume_eb(0) = 1
	log("costume_eb 0 set 0")
	costume_order_change = 0	
End Sub

Sub fight_parm_tmp
	Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 6//cba 三个技能都是6t cd
		i=i+1
	Next
	i=0
	For 9 
		fight_target(i) = 3
		i=i+1
	Next
	
	skill_eb_turn(5) = 0 //cba1 充能 
	
	hougu_eb_turn(1) = 0
	
	costume_eb(1) = 2
	costume_eb(0) = 2
	costume_eb(2) = 99
End Sub

//孔明566 梅林576  c呆656
Sub fight_parm_sikaha_lan_sikaha
	Dim i
	Call fight_parm_default
	skill_eb_turn(2) = 2 //cba1 充能 
	skill_eb_turn(8) = 0//cba2 1回合充能
	i=0
	For 9 
		skill_cd(i) = 6//cba 三个技能都是6t cd
		i=i+1
	Next
		
	skill_cd(4) = 5 //狂兰 23 技能 5t
	skill_cd(5) = 5
	costume_eb(0) = 2
	costume_eb(2) = 1 //turn1换人开技能 
	costume_order_change = 1//打开换人服
	log("fight parm cba ")
End Sub
Sub fight_parm_mutuki_lilith
	//turn 从0开始
	Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 6 //其他默认搞6
		i=i+1
	Next
		
	skill_cd(3) = 4 //莉莉丝技能cd
	skill_cd(4) = 6 //
	skill_cd(5) = 5
	
	skill_eb_turn(0) = 0//cba2 1回合充能
	skill_eb_turn(1) = 0//cba2 1回合充能
	skill_eb_turn(2) = 0//cba2 1回合充能
	skill_eb_turn(3) = 0//cba2 1回合充能
	skill_eb_turn(4) = 0//cba2 1回合充能
	skill_eb_turn(5) = 3//cba2 1回合充能 
	skill_eb_turn(6) = 0//cba2 1回合充能
	skill_eb_turn(7) = 0//cba2 1回合充能
	skill_eb_turn(8) = 0//cba2 1回合充能
	
	hougu_eb_turn(0) = 5
	hougu_eb_turn(1) = 0
	hougu_eb_turn(2) = 5
	costume_eb(0) = 2
	costume_eb(1) = 2
	costume_eb(2) = 2
	skill_double = 1
	//costume_eb(2) = 1 //turn1换人开技能 
	//costume_order_change = 1//打开换人服
	log("fight parm lilith ")
	
End Sub
Sub fight_parm_redA
	//turn 从0开始
	Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 99 //其他默认搞6
		i=i+1
	Next
	
//	skill_cd(1) = 5 //c呆cd	
//	skill_cd(7) = 5 //c呆cd	
//	skill_cd(3) = 4 //阿荣技能cd
//	skill_cd(4) = 5 //
//	skill_cd(5) = 6
	
//	skill_eb_turn(0) = 1//cba2 1回合充能
//	skill_eb_turn(1) = 1//cba2 1回合充能
//	skill_eb_turn(2) = 1//cba2 1回合充能
//	skill_eb_turn(3) = 1//第二回合回收75 回30
//	skill_eb_turn(4) = 1//cba2 1回合充能
//	skill_eb_turn(5) = 1//cba2 1回合充能 
//	skill_eb_turn(6) = 1//cba2 1回合充能
//	skill_eb_turn(7) = 1//cba2 1回合充能
//	skill_eb_turn(8) = 1//cba2 1回合充能
//	
//	skill_person(5) = 0
//	skill_person(7) = 1
	
	hougu_eb_turn(0) = 99 //尽量留一下宝具防止被秒 3t进入 4格气槽 1格充能 3+4-1-1
	hougu_eb_turn(1) = 99
	hougu_eb_turn(2) = 99
	costume_eb(0) = 99
	costume_eb(1) = 99
	costume_eb(2) = 99
//	skill_double = 1
//	
//	fight_target(3) = 3 //1 2 3 没有0//垫刀
//	fight_target(4) = 3 
//	fight_target(5) = 3 
//	fight_target(6) = 3 
//	fight_target(7) = 3 
//	fight_target(8) = 3 
	//target_person = 1
	//costume_eb(2) = 1 //turn1换人开技能 
	//costume_order_change = 1//打开换人服
	log("fight parm rong ")
		
End Sub
Sub fight_parm_rong
	//turn 从0开始
	Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 6 //其他默认搞6
		i=i+1
	Next
	
//	skill_cd(1) = 5 //c呆cd	
//	skill_cd(7) = 5 //c呆cd	
	skill_cd(3) = 4 //阿荣技能cd
//	skill_cd(4) = 5 //
//	skill_cd(5) = 6
	
	skill_eb_turn(0) = 0//cba2 1回合充能
	skill_eb_turn(1) = 1//cba2 1回合充能
	skill_eb_turn(2) = 1//cba2 1回合充能
	skill_eb_turn(3) = 0//第二回合回收75 回30
	skill_eb_turn(4) = 2//cba2 1回合充能
	skill_eb_turn(5) = 2//cba2 1回合充能 
	skill_eb_turn(6) = 0//cba2 1回合充能
	skill_eb_turn(7) = 0//cba2 1回合充能
	skill_eb_turn(8) = 0//cba2 1回合充能
	
	skill_person(6) = 0
	skill_person(7) = 0
	
	hougu_eb_turn(0) = 1 //尽量留一下宝具防止被秒 3t进入 4格气槽 1格充能 3+4-1-1
	hougu_eb_turn(1) = 0
	hougu_eb_turn(2) = 0
	costume_eb(0) = 99
	costume_eb(1) = 99
	costume_eb(2) = 99
	skill_double = 1
	
	fight_target(3) = 3 //1 2 3 没有0//垫刀
	fight_target(4) = 3 
	fight_target(5) = 3 
	fight_target(6) = 3 
	fight_target(7) = 3 
	fight_target(8) = 3 
	//target_person = 1
	//costume_eb(2) = 1 //turn1换人开技能 
	//costume_order_change = 1//打开换人服
	log("fight parm rong ")
		
End Sub
Sub fight_parm_sige_change
		Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 6 //其他默认搞6
		i=i+1
	Next
	
	
	
	skill_eb_turn(0) = 5//
	skill_eb_turn(1) = 0//
	skill_eb_turn(2) = 5//
	skill_eb_turn(3) = 0//第二回合保证回收
	skill_eb_turn(4) = 0//第三回合增伤充能
	skill_eb_turn(5) = 7//
	skill_eb_turn(6) = 0//c呆上来充满
	skill_eb_turn(7) = 0//
	skill_eb_turn(8) = 0//
	
	hougu_eb_turn(0) = 5 //1t c妈干掉
	hougu_eb_turn(1) = 0 //2t 齐格上去喷
	hougu_eb_turn(2) = 0
	costume_eb(0) = 2//0t 需要补充伤害
	costume_eb(1) = 2 //锤晕免得乱动
	costume_eb(2) = 2
	costume_order_change = 2//打开换人服
	skill_double = 1
	
	fight_target(3) = 3 //1 2 3 没有0//垫刀
	fight_target(4) = 3 
	fight_target(5) = 3 
	fight_target(6) = 3 
	fight_target(7) = 3 
	fight_target(8) = 3 
	//target_person = 1
	//costume_eb(2) = 1 //turn1换人开技能 
	
	log("fight parm sige ")
		
End Sub
Sub fight_parm_sige_single
			Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 6 //其他默认搞6
		i=i+1
	Next
	
	
	skill_cd(1) = 5 //c呆cd	
	skill_cd(7) = 5 //c呆cd	
	skill_cd(3) = 7 //齐格766 
	
	skill_eb_turn(0) = 0//充满
	skill_eb_turn(1) = 0//
	skill_eb_turn(2) = 0//
	skill_eb_turn(3) = 1//第二回合保证回收
	skill_eb_turn(4) = 1//
	skill_eb_turn(5) = 2//
	skill_eb_turn(6) = 1//第二回合充满
	skill_eb_turn(7) = 1//
	skill_eb_turn(8) = 0//
	
	hougu_eb_turn(0) = 0 
	hougu_eb_turn(1) = 0 
	hougu_eb_turn(2) = 0
	costume_eb(0) = 99//
	costume_eb(1) = 1 //补伤害
	costume_eb(2) = 99
	skill_double = 1
	
	fight_target(3) = 3 //1 2 3 没有0//垫刀
	fight_target(4) = 3 
	fight_target(5) = 3 
	fight_target(6) = 3 
	fight_target(7) = 3 
	fight_target(8) = 3 
	//target_person = 1
	//costume_eb(2) = 1 //turn1换人开技能 
	
	log("fight parm single single")
		
End Sub

Sub fight_parm_stella
			Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 6 //其他默认搞6
		i=i+1
	Next
	
	
	skill_cd(1) = 5 //c呆cd	
	skill_cd(2) = 0 //2t 3t都要放	
	
	skill_eb_turn(0) = 2//充满
	skill_eb_turn(1) = 2//
	skill_eb_turn(2) = 0//
	skill_eb_turn(3) = 0//躲技能
	skill_eb_turn(4) = 0//
	skill_eb_turn(5) = 0//
	skill_eb_turn(6) = 1//第二回合充满
	skill_eb_turn(7) = 2//
	skill_eb_turn(8) = 2//
	
	hougu_eb_turn(0) = 0 
	hougu_eb_turn(1) = 0 
	hougu_eb_turn(2) = 0
	costume_eb(0) = 99//
	costume_eb(1) = 2 //补伤害
	costume_eb(2) = 99
	skill_double = 1
	
	fight_target(3) = 3 //1 2 3 没有0//垫刀
	fight_target(4) = 3 
	fight_target(5) = 3 
	fight_target(6) = 3 
	fight_target(7) = 3 
	fight_target(8) = 3 
	//target_person = 1
	//costume_eb(2) = 1 //turn1换人开技能 
	
	log("fight parm sige single")
		
End Sub
Sub fight_parm_saber
	Dim i
	Call fight_parm_default
	i=0
	For 9 
		skill_cd(i) = 6 //其他默认搞6
		i=i+1
	Next
	
	skill_cd(3) = 5 
	skill_cd(4) = 5 
	skill_cd(5) = 5 	
	skill_cd(7) = 5 //c呆cd	
	
	skill_eb_turn(0) = 1//turn1充能
	skill_eb_turn(1) = 1//顺便开技能
	skill_eb_turn(2) = 1//
	skill_eb_turn(3) = 0//
	skill_eb_turn(4) = 2//第三回合增伤
	skill_eb_turn(5) = 0//充满
	skill_eb_turn(6) = 0//c呆上来充满
	skill_eb_turn(7) = 0//
	skill_eb_turn(8) = 0//
	
	hougu_eb_turn(0) = 1 //1t c妈干掉
	hougu_eb_turn(1) = 0 //2t 齐格上去喷
	hougu_eb_turn(2) = 0
	costume_eb(0) = 2//需要补充伤害
	costume_eb(1) = 2 //锤晕免得乱动
	costume_eb(2) = 1
	costume_order_change = 1//打开换人服
	skill_double = 1
	
	fight_target(0) = 2 
	fight_target(1) = 2 
	fight_target(2) = 2 
	//target_person = 1
	//costume_eb(2) = 1 //turn1换人开技能 
	
	log("fight parm sige ")
		
End Sub
Sub saveColor
	mission_screen_x(0) = 160 //左上角的返回
	mission_screen_y(0) = 114
	mission_screen_c(0) = "E5E5E4"
	mission_screen_x(1) = 235 //圣晶石的一个角
	mission_screen_y(1) = 611
	mission_screen_c(1) = "B2EE76"
	mission_screen_x(2) = 519 //圣晶石的一个角
	mission_screen_y(2) = 729
	mission_screen_c(2) = "F9E34E"
	mission_screen_x(3) = 167 //右下角菜单的白色
	mission_screen_y(3) = 720
	mission_screen_c(3) = "93D8ED"
	mission_screen_x(4) = 1212 //右上角菜单的蓝色
	mission_screen_y(4) = 91
	mission_screen_c(4) = "397FB3"
	mission_screen_x(5) = 1017 //右上角资源数的位置，用来瞎点 
	mission_screen_y(5) = 95
	mission_screen_c(5) = "B3A346"


	i = 0
	For 5
		mission_screen_c(i)=GetPixelColor(mission_screen_x(i),mission_screen_y(i))		
		i = i+1
	Next
	
End Sub

Sub mark_success
	log("mark success")
	While true
		MoveTo 0, 0
		Delay 1000

	Wend

End Sub
Sub script_failed
	RunApp "D:\PixivPitcher\sendmail.bat"
	Delay 10000

	If reboot_enable Then 
		Call reboot_fgo()
	Else 
		Call mark_failed //不重启的话就assert在这里
	End If
End Sub

Sub reboot_fgo
	Dim boot_battle_x(4)
	Dim boot_battle_y(4)
	Dim boot_battle_c(4)
	Dim fgo_logo_x(5)
	Dim fgo_logo_y(5)
	Dim fgo_logo_c(5)
	boot_battle_x(0)=499
	boot_battle_y(0)=588
	boot_battle_c(0)="D6D6D5"//左边的不进入
	boot_battle_x(1)=880
	boot_battle_y(1)=588
	boot_battle_c(1)="D6D5D4"//右边的进入
	boot_battle_x(2)=1199
	boot_battle_y(2)=74
	boot_battle_c(2) = "41B5FF"//右上角R16
	boot_battle_x(3)=1167
	boot_battle_y(3)=91
	boot_battle_c(3) = "F8FEFE"//右上角R16
	
	fgo_logo_x(0) = 174//随便取了图标上5个点
	fgo_logo_y(0) = 211
	fgo_logo_c(0) = "C95F51"
	fgo_logo_x(1) = 194
	fgo_logo_y(1) = 210
	fgo_logo_c(1) = "6CAEE8"
	fgo_logo_x(2) = 209
	fgo_logo_y(2) = 209
	fgo_logo_c(2) = "76B0E3"
	fgo_logo_x(3) = 198
	fgo_logo_y(3) = 229
	fgo_logo_c(3) = "A3C3EA"
	fgo_logo_x(4) = 197
	fgo_logo_y(4) = 253
	fgo_logo_c(4) = "93939E"

	MoveTo 418, 17 //关闭fgo图标
	LeftClick 1
	log("wait fgo close")
	For 600
	//等到桌面跳出来
		Delay 2000

		tmp = check_point_color(fgo_logo_x,fgo_logo_y,fgo_logo_c,5)
		
		If tmp = 1 Then 
			Goto reboot_mark_1
		End If
		MoveTo 418, 17 //关闭fgo图标
		LeftClick 1
		
	Next
	log("fgo close failed")
	Call mark_failed() //断言 十分钟不成就完全不行了 也没办法
	Rem reboot_mark_1
	log("start fgo")
	
	For 600
		MoveTo fgo_logo_x(0), fgo_logo_y(0) //点fgo图标
		LeftClick 1
		
		Delay 200
		MoveTo 418,17 //点fgo图标
		Delay 1800
		tmp = check_point_color(fgo_logo_x,fgo_logo_y,fgo_logo_c,5)
		
		If tmp = 0 Then 
			Goto reboot_mark_2
		End If
		
	Next
	log("fgo start failed")
	
	Rem reboot_mark_2
	log("fgo try into homepage")
	
	For 600 
		MoveTo 80, 372//点击直到进入桌面或者卡住
		LeftClick 1
		Delay 1000
		tmp = check_point_color(boot_battle_x,boot_battle_y,boot_battle_c,4) //function必须要有个返回值
		If tmp = 1 Then 
			MoveTo boot_battle_x(0), boot_battle_y(0)//点不进入
			LeftClick 1
			log ("skip last fight")
			Goto reboot_mark_2
			
			Delay 1000
		End If
		
		tmp = check_station()
		If tmp = 1 Then 
			MoveTo 1199, 78 //点×
			LeftClick 1
			Delay 5000
		
			MoveTo 400, 599 // 点确认友情点
			LeftClick 1
			Delay 5000
			MoveTo 400, 599 // 点确认友情点
			LeftClick 1
			Delay 200
			MoveTo 400, 599 // 点确认友情点
			LeftClick 1
			Delay 200
			
			MoveTo 768, 419 //点活动
			LeftClick 1
			Goto reboot_mark_4
		End If
	Next

	
	Rem reboot_mark_4
	
	
	tmp = check_station()
	log("now check station")
	If tmp = 2 Then 
		RunApp "D:\PixivPitcher\sendmailsuccess.bat"
	Else 
		log("reboot failed")
		RunApp "D:\PixivPitcher\sendmailfailed.bat"
		Call mark_failed()
	End If
	
	Call system_run
	//1 进入公告栏
	//2 没进公告栏 直接进战斗界面
	log("reboot success")
	//Call mark_failed()
End Sub
Sub mark_failed
	log("mark failed")
	While true
		MoveTo 1365, 0
		Delay 1000

	Wend

End Sub

Sub test // 函数测试代码
	Call go_mission_screen()
	Call mark_success()
	
End Sub
Function print_color(x, y,c, size)
	Dim j
	j=0
	For size
		TracePrint j
		TracePrint c(j)
		GetColor=GetPixelColor(x(j),y(j))
		TracePrint GetColor
		j=j+1	
	Next
End Function
