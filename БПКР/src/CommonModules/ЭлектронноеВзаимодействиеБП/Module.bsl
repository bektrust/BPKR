
#Область СлужебныйПрограммныйИнтерфейс

#Область КонвертацияФорматированногоДокументаВФорматRTF

// Преобразует форматированный документ 1С в документ формата RTF
Процедура КонвертироватьВФорматRTF(ФорматированныйДокумент, ИмяФайла) Экспорт
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.ANSI);
	
	СоответствиеТегов = ПолучитьСоответствиеТегов(ФорматированныйДокумент);
	ЗаписьТекста.ЗаписатьСтроку(НачалоRTF(СоответствиеТегов));
	НомерСписка = 0;
	Для Каждого Параграф Из ФорматированныйДокумент.Элементы Цикл
		
		Если Параграф.ТипПараграфа = ТипПараграфа.НумерованныйСписок Тогда
			
			НомерСписка = НомерСписка + 1;
			
		Иначе
			
			НомерСписка = 0;
			
		КонецЕсли;
		ПараграфRTF = ОбработатьПараграф(Параграф, СоответствиеТегов, НомерСписка);
		ЗаписьТекста.ЗаписатьСтроку(ПараграфRTF);
		
	КонецЦикла;
	ЗаписьТекста.ЗаписатьСтроку(КонецRTF());
	
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КонвертацияФорматированногоДокументаВФорматRTF

Функция ПолучитьСоответствиеТегов(ФорматированныйДокумент)
	
	СоответствиеWebЦветов = Новый Соответствие;
	ЦветаWeb = ПолучитьОбщийМакет("WebЦветаRGB");
	ВысотаТаблицы = ЦветаWeb.ВысотаТаблицы;
	Для Н = 2 По ВысотаТаблицы Цикл
		
		Ключ = НРег(СокрЛП(ЦветаWeb.Область(Н, 1).Текст));
		Значение = СокрЛП(ЦветаWeb.Область(Н, 2).Текст);
		СоответствиеWebЦветов.Вставить(Ключ, Значение);
		
	КонецЦикла;
	
	СоответствиеТегов = Новый Соответствие;
	СоответствиеЦветовRGB = Новый Соответствие;
	
	// Получаем шрифты и цвета, используемые в документе
	СоответствиеТегов.Вставить("Arial", "\f0");
	СчетчикШрифтов = 1;
	СчетчикЦветов = 0;
	ТаблицаШрифтов = "{\f0\fnil\fcharset0 Arial;}{\f1\fnil\fcharset2 Symbol;}";
	ТаблицаЦветов = "";
	Для Каждого Параграф Из ФорматированныйДокумент.Элементы Цикл
		
		Для Каждого Элемент Из Параграф.Элементы Цикл
			
			Если ТипЗнч(Элемент) = Тип("ТекстФорматированногоДокумента") Тогда
				
				Шрифт = Элемент.Шрифт;
				Если ЗначениеЗаполнено(Шрифт.Имя) Тогда
					
					Если СоответствиеТегов[Шрифт.Имя] = Неопределено Тогда
						
						СчетчикШрифтов = СчетчикШрифтов + 1;
						Ключ = Шрифт.Имя;
						Значение = "\f" + Формат(СчетчикШрифтов, "ЧГ=0");
						СоответствиеТегов.Вставить(Ключ, Значение);
						ТаблицаШрифтов = ТаблицаШрифтов + "{" + Значение + "\fnil\fcharset0 " + Ключ + ";}";
						
					КонецЕсли;
					
				КонецЕсли;
				
				ЦветТекста = Элемент.ЦветТекста;
				Если ЦветТекста.Вид = ВидЦвета.WebЦвет 
					ИЛИ ЦветТекста.Вид = ВидЦвета.ЭлементСтиля 
					ИЛИ ЦветТекста.Вид = ВидЦвета.Абсолютный Тогда
					
					Если СоответствиеТегов[ЦветТекста] = Неопределено Тогда
						
						ЦветRGB = ПолучитьЦветRGB(СоответствиеWebЦветов, ЦветТекста);
						ТегЦвета = СоответствиеЦветовRGB[ЦветRGB];
						Если ТегЦвета = Неопределено Тогда
							
							СчетчикЦветов = СчетчикЦветов + 1;
							ТегЦвета = Формат(СчетчикЦветов, "ЧГ=0");
							СоответствиеЦветовRGB.Вставить(ЦветRGB, ТегЦвета);
							ТаблицаЦветов = ТаблицаЦветов + ЦветRGB;
							
						КонецЕсли;
						СоответствиеТегов.Вставить(ЦветТекста, ТегЦвета);
						
					КонецЕсли;
					
				КонецЕсли;
				
				ЦветФона = Элемент.ЦветФона;
				Если ЦветФона.Вид = ВидЦвета.WebЦвет 
					ИЛИ ЦветФона.Вид = ВидЦвета.ЭлементСтиля 
					ИЛИ ЦветФона.Вид = ВидЦвета.Абсолютный Тогда
					
					Если СоответствиеТегов[ЦветФона] = Неопределено Тогда
						
						ЦветRGB = ПолучитьЦветRGB(СоответствиеWebЦветов, ЦветФона);
						Если ЗначениеЗаполнено(ЦветRGB) Тогда
							
							ТегЦвета = СоответствиеЦветовRGB[ЦветRGB];
							Если ТегЦвета = Неопределено Тогда
								
								СчетчикЦветов = СчетчикЦветов + 1;
								ТегЦвета = Формат(СчетчикЦветов, "ЧГ=0");
								СоответствиеЦветовRGB.Вставить(ЦветRGB, ТегЦвета);
								ТаблицаЦветов = ТаблицаЦветов + ЦветRGB;
								
							КонецЕсли;
							СоответствиеТегов.Вставить(ЦветФона, ТегЦвета);
						
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	СоответствиеТегов.Вставить("ТаблицаШрифтов", ТаблицаШрифтов);
	СоответствиеТегов.Вставить("ТаблицаЦветов", ТаблицаЦветов);
	
	// Положение текста
	СоответствиеТегов.Вставить(ГоризонтальноеПоложение.Лево,	 "\ql");
	СоответствиеТегов.Вставить(ГоризонтальноеПоложение.Право,	 "\qr");
	СоответствиеТегов.Вставить(ГоризонтальноеПоложение.Центр,	 "\qc");
	СоответствиеТегов.Вставить(ГоризонтальноеПоложение.ПоШирине, "\qj");
	
	Возврат СоответствиеТегов;
	
КонецФункции

Функция ПолучитьЦветRGB(СоответствиеWebЦветов, Цвет)
	
	ЭтоВебЦвет = Цвет.Вид = ВидЦвета.WebЦвет;
	НазваниеЦвета = "";
	
	Если Цвет.Вид = ВидЦвета.ЭлементСтиля Тогда
		
		ФорматированныйДокумент = Новый ФорматированныйДокумент;
		ЭлементДокумента = ФорматированныйДокумент.Добавить("Цвет");
		ЭлементДокумента.ЦветТекста = Цвет;
		ТекстHTML = "";
		ВложенияHTML = Неопределено;
		ФорматированныйДокумент.ПолучитьHTML(ТекстHTML, ВложенияHTML);
		НачПозицияЗначенияЦвета = СтрНайти(ТекстHTML, "color:");
		Если НачПозицияЗначенияЦвета > 0 Тогда
			
			КонПозицияЗначенияЦвета = СтрНайти(ТекстHTML, ";",, НачПозицияЗначенияЦвета);
			СтрЦвета = Сред(ТекстHTML, НачПозицияЗначенияЦвета, КонПозицияЗначенияЦвета - НачПозицияЗначенияЦвета);
			
			Если СтрНайти(СтрЦвета, "#") > 0 Тогда
				
				Массив = СтрРазделить(СтрЦвета, "#", Ложь);
				Цвет16 = СокрЛП(Массив[1]);
				Красный = HexToDec(Лев(Цвет16, 2));
				Зеленый = HexToDec(Сред(Цвет16, 3, 2));
				Синий  = HexToDec(Сред(Цвет16, 5, 2));
				Результат = "\red" + Красный + "\green" + Зеленый + "\blue" + Синий + ";";
				
				Возврат Результат;
				
			Иначе
				
				Массив = СтрРазделить(СтрЦвета, "#", Ложь);
				НазваниеЦвета = СокрЛП(Массив[1]);
				
			КонецЕсли;
			
		Иначе
			
			Возврат "";
			
		КонецЕсли;
		
	ИначеЕсли Цвет.Вид = ВидЦвета.Абсолютный Тогда
		
		Результат = "\red" + Цвет.Красный + "\green" + Цвет.Зеленый + "\blue" + Цвет.Синий + ";";
		
		Возврат Результат;
		
	КонецЕсли;
		
	Если ЭтоВебЦвет Тогда
		
		Если Не ЗначениеЗаполнено(НазваниеЦвета) Тогда
			
			НазваниеЦвета = НРег(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("()",
				СтрРазделить(Строка(Цвет), "(")[1], ""));
				
		КонецЕсли;
		ЦветRGB = СоответствиеWebЦветов[НазваниеЦвета];
		Если ЦветRGB = Неопределено Тогда
			
			Возврат "";
			
		Иначе
			
			МассивRGB = СтрРазделить(ЦветRGB, " ", Ложь);
			Результат = "\red" + СокрЛП(МассивRGB[0]) + "\green" + СокрЛП(МассивRGB[1]) + "\blue" + СокрЛП(МассивRGB[2]) + ";";
			Возврат Результат;
			
		КонецЕсли;
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;

КонецФункции

// Преобразуем шестнадцатеричное число в десятичное
Функция HexToDec(СтрокаHex)
	
	ДлинаСтроки = СтрДлина(СтрокаHex);
	ЧислоDec = 0;
	Для Н = 0 По ДлинаСтроки - 1 Цикл
		
		Множитель = Pow(16 , Н);
		СимволСтроки = НРег(Сред(СтрокаHex, ДлинаСтроки - Н, 1));
		Если СимволСтроки = "a" Тогда
			
			ЧислоDec = ЧислоDec + 10 * Множитель;
			
		ИначеЕсли СимволСтроки = "b" Тогда
			
			ЧислоDec = ЧислоDec + 11 * Множитель;
			
		ИначеЕсли СимволСтроки = "c" Тогда
			
			ЧислоDec = ЧислоDec + 12 * Множитель;
			
		ИначеЕсли СимволСтроки = "d" Тогда
			
			ЧислоDec = ЧислоDec + 13 * Множитель;
			
		ИначеЕсли СимволСтроки = "e" Тогда
			
			ЧислоDec = ЧислоDec + 14 * Множитель;
			
		ИначеЕсли СимволСтроки = "f" Тогда
			
			ЧислоDec = ЧислоDec + 15 * Множитель;
			
		Иначе
			
			ЧислоDec = ЧислоDec + СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СимволСтроки) * Множитель;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЧислоDec;
	
КонецФункции

Функция НачалоRTF(СоответствиеТегов)
	
	Значение = "{\rtf1\ansi\ansicpg1251\deff0{\fonttbl" + СоответствиеТегов["ТаблицаШрифтов"] 
		+ "}" + Символы.ПС;
	
	ТаблицаЦветов = СоответствиеТегов["ТаблицаЦветов"];
	Если ЗначениеЗаполнено(ТаблицаЦветов) Тогда
		
		Значение = Значение + "{\colortbl;" + ТаблицаЦветов + "}" + Символы.ПС;
		
	КонецЕсли;
	
	Значение = Значение + "\viewkind4\uc1\sa200\lang9\paperw11906\paperh16838";
	
	Возврат Значение;
	
КонецФункции

Функция КонецRTF()
	
	Возврат "}";
	
КонецФункции

Функция ОбработатьПараграф(Параграф, СоответствиеТегов, НомерСписка)
	
	Отступ = ?(Параграф.Отступ = 0, "", "\li" + Формат(Параграф.Отступ * 20, "ЧГ=0"));
	Если Параграф.ТипПараграфа = ТипПараграфа.МаркированныйСписок Тогда
		
		ВидСписка = "{\pntext\f1\'B7\tab}{\*\pn\pnlvlblt\pnf1\pnindent200{\pntxtb\'B7}}";
		Если Не ЗначениеЗаполнено(Отступ) Тогда
			
			ВидСписка = ВидСписка + "\li400";
			
		КонецЕсли;
		
	ИначеЕсли Параграф.ТипПараграфа = ТипПараграфа.НумерованныйСписок Тогда
		
		ВидСписка = "{\pntext\f0 " + Формат(НомерСписка, "ЧГ=0") +".\tab}"
			+ "{\*\pn\pnlvlbody\pnf0\pnindent300\pnstart1\pndec{\pntxta.}}";
			
		Если Не ЗначениеЗаполнено(Отступ) Тогда
			
			ВидСписка = ВидСписка + "\li400";
			
		КонецЕсли;
			
	Иначе
		
		ВидСписка = "";
		
	КонецЕсли;
	
	Данные = "\pard"
		+ СоответствиеТегов[Параграф.ГоризонтальноеПоложение]
		+ "\sl" + Формат(Параграф.МеждустрочныйИнтервал * 240, "ЧДЦ=0; ЧГ=0") + "\slmult1"
		+ Отступ
		+ ВидСписка;
		
	КоличествоЭлементов = Параграф.Элементы.Количество();
	Счетчик = 0;
	Для Каждого Элемент Из Параграф.Элементы Цикл
		
		Счетчик = Счетчик + 1;
		Если ТипЗнч(Элемент) = Тип("ТекстФорматированногоДокумента") Тогда
			
			Данные = Данные + ОбработатьТекст(Элемент, СоответствиеТегов);
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("ПереводСтрокиФорматированногоДокумента") Тогда
			
			Если Счетчик < КоличествоЭлементов Тогда
				
				Данные = Данные + "\line";
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Данные = Данные + "\par";
		
	Возврат Данные;
	
КонецФункции

Функция ОбработатьТекст(ЭлементТекст, СоответствиеТегов)

	Данные = ШрифтТекста(ЭлементТекст, СоответствиеТегов) + " ";
		
	Текст = ЭлементТекст.Текст;
	ДлинаСтроки = СтрДлина(Текст);
	Для Н = 1 По ДлинаСтроки Цикл
		
		Код = Формат(КодСимвола(Текст, Н), "ЧВН=; ЧГ=0");
		Данные = Данные + "\u" + Код + "?"; // символ в Unicode, если символ не распознан - вывод знака вопроса
		
	КонецЦикла;
	Данные = Данные + ШрифтТекста(ЭлементТекст, СоответствиеТегов, Истина);
	
	Возврат Данные;

КонецФункции

Функция ШрифтТекста(ЭлементТекста, СоответствиеТегов, ЗакрывающийТег = Ложь)
	
	Значение		 = "";
	Шрифт			 = ЭлементТекста.Шрифт;
	ЦветТекста		 = ЭлементТекста.ЦветТекста;
	ЦветФона		 = ЭлементТекста.ЦветФона;
	Если Не ЗакрывающийТег Тогда
		
		Если ЗначениеЗаполнено(Шрифт.Имя) Тогда
			
			ТегШрифта = СоответствиеТегов[Шрифт.Имя];
			Значение = Значение + ?(ТегШрифта = Неопределено, "", ТегШрифта); // определяем шрифт
			
		Иначе
			
			Значение = Значение + "\f0"; // шрифт по умолчанию
			
		КонецЕсли;
		Если Шрифт.Размер <> Неопределено Тогда
			
			Значение = Значение + ?(Шрифт.Размер = -1 ИЛИ Шрифт.Размер = 0, "\fs20", "\fs" + Формат(Шрифт.Размер * 2, "ЧГ=0"));
			
		КонецЕсли;
		
	КонецЕсли;
	Если Шрифт.Полужирный <> Неопределено Тогда 
		
		Значение = Значение + ?(Шрифт.Полужирный, ?(ЗакрывающийТег, "\b0", "\b"), "");
		
	КонецЕсли;
	Если Шрифт.Наклонный <> Неопределено Тогда
		
		Значение = Значение + ?(Шрифт.Наклонный, ?(ЗакрывающийТег, "\i0", "\i"), "");
		
	КонецЕсли;
	Если Шрифт.Подчеркивание <> Неопределено Тогда
		
		Значение = Значение + ?(Шрифт.Подчеркивание, ?(ЗакрывающийТег, "\ulnone", "\ul"), "");
		
	КонецЕсли;
	Если Шрифт.Зачеркивание <> Неопределено Тогда
		
		Значение = Значение + ?(Шрифт.Зачеркивание, ?(ЗакрывающийТег, "\strike0", "\strike"), "");
		
	КонецЕсли;
	Если ЦветТекста.Вид = ВидЦвета.Абсолютный
		ИЛИ ЦветТекста.Вид = ВидЦвета.WebЦвет
		ИЛИ ЦветТекста.Вид = ВидЦвета.ЭлементСтиля Тогда
		
		НомерЦвета = СоответствиеТегов[ЦветТекста];
		Если ЗначениеЗаполнено(НомерЦвета) Тогда
			
			Значение = Значение + ?(ЗакрывающийТег, "\cf0", "\cf" + НомерЦвета);
			
		КонецЕсли;
		
	КонецЕсли;
	Если ЦветФона.Вид = ВидЦвета.Абсолютный
		ИЛИ ЦветФона.Вид = ВидЦвета.WebЦвет
		ИЛИ ЦветФона.Вид = ВидЦвета.ЭлементСтиля Тогда
		
		НомерЦвета = СоответствиеТегов[ЦветФона];
		Если ЗначениеЗаполнено(НомерЦвета) Тогда
			
			Значение = Значение + ?(ЗакрывающийТег, "\highlight0", "\highlight" + НомерЦвета);
			
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Значение;
	
КонецФункции

#КонецОбласти

#КонецОбласти
