#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьГрафикНачислений(Параметры);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьГрафикНачислений(Параметры)
	Запрос = Новый Запрос;
	Запрос.Текст = 		
		"ВЫБРАТЬ
		|	0 КАК Ключ
		|ПОМЕСТИТЬ Порядки
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	1
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	2
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	3
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	4
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	5
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	6
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	7
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	8
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	9
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	10
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	11
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ), МЕСЯЦ, П1.Ключ) КАК МЕСЯЦ
		|ПОМЕСТИТЬ ВременнаяТаблицаМесяцы
		|ИЗ
		|	Порядки КАК П1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Порядки КАК П2
		|		ПО (ИСТИНА)
		|ГДЕ
		|	П1.Ключ <= РАЗНОСТЬДАТ(&НачалоПериода, &КонецПериода, МЕСЯЦ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаМесяцы.МЕСЯЦ КАК Месяц,
		|	ХозрасчетныйОборотыДтКт.СуммаОборот КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаМесяцы КАК ВременнаяТаблицаМесяцы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, Месяц, , , СчетКт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасходыБудущихПериодов), , СубконтоКт1 = &РасходыСсылка) КАК ХозрасчетныйОборотыДтКт
		|		ПО ВременнаяТаблицаМесяцы.МЕСЯЦ = ХозрасчетныйОборотыДтКт.Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	Месяц";	
	
	Запрос.УстановитьПараметр("РасходыСсылка", 	Параметры.РасходыСсылка);
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоМесяца(Параметры.НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецМесяца(Параметры.КонецПериода));
		
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТаблицыЗначений = ГрафикНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыЗначений, ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьГрафикНачислений(Параметры)

#КонецОбласти