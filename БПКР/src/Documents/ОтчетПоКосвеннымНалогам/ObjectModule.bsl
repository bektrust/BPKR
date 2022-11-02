#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокумент() Экспорт
	
	ЗаполнитьПриложение1();
	ЗаполнитьПриложение2();
	ЗаполнитьПриложение3();
	ЗаполнитьПриложение4();
	ЗаполнитьПриложение5();
	ЗаполнитьПриложение9();
	ЗаполнитьОсновнаяФорма();	

КонецПроцедуры

Процедура ЗаполнитьПриложение1()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПредметыЛизинга)
		|			ТОГДА ""150""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПродуктыПереработкиДС)
		|			ТОГДА ""151""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ТранспортныеСредства)
		|			ТОГДА ""152""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.Прочее)
		|			ТОГДА ""153""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ИмпортТоваровСМУКЦ)
		|			ТОГДА ""198""
		|	КОНЕЦ КАК КодСтроки,
		|	ТаблицаПоказателиИмпорта.Ссылка КАК Содержание,
		|	СУММА(НДСНаИмпортОбороты.СуммаОборот) КАК Сумма,
		|	СУММА(НДСНаИмпортОбороты.СуммаНДСОборот) КАК СуммаНДС
		|ИЗ
		|	Перечисление.ПоказателиИмпорта КАК ТаблицаПоказателиИмпорта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.НДСНаИмпорт.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК НДСНаИмпортОбороты
		|		ПО ТаблицаПоказателиИмпорта.Ссылка = НДСНаИмпортОбороты.ПоказательИмпорта
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПредметыЛизинга)
		|			ТОГДА ""150""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПродуктыПереработкиДС)
		|			ТОГДА ""151""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ТранспортныеСредства)
		|			ТОГДА ""152""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.Прочее)
		|			ТОГДА ""153""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ИмпортТоваровСМУКЦ)
		|			ТОГДА ""198""
		|	КОНЕЦ,
		|	ТаблицаПоказателиИмпорта.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодСтроки";		
	Запрос.УстановитьПараметр("НачалоПериода", 			НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", 			КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", 			Организация);	
	
	Приложение1.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтрокаТабличнойЧасти = Приложение1.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 		= "199";
	СтрокаТабличнойЧасти.Содержание		= НСтр("ru = 'Итого облагаемый импорт (= сумма ячеек 150-198)'");
	СтрокаТабличнойЧасти.Сумма 			= Приложение1.Итог("Сумма");
	СтрокаТабличнойЧасти.СуммаНДС 		= Приложение1.Итог("СуммаНДС");
КонецПроцедуры

Процедура ЗаполнитьПриложение2()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОВвозимыхТоварах.КодСтраны КАК КодСтраны,
		|	СведенияОВвозимыхТоварах.НомерДокумента КАК НомерЗаявления,
		|	СведенияОВвозимыхТоварах.Дата КАК ДатаЗаявления,
		|	СУММА(СведенияОВвозимыхТоварах.СуммаАкциза) КАК СуммаАкцизногоНалога,
		|	СУММА(СведенияОВвозимыхТоварах.СуммаНДС) КАК СуммаНДС,
		|	СУММА(СведенияОВвозимыхТоварах.СуммаНДСЗачет) КАК СуммаНДСЗачет,
		|	СУММА(СведенияОВвозимыхТоварах.Стоимость) КАК СтоимостьТовара
		|ИЗ
		|	РегистрСведений.СведенияОВвозимыхТоварах КАК СведенияОВвозимыхТоварах
		|ГДЕ
		|	СведенияОВвозимыхТоварах.Организация = &Организация
		|	И СведенияОВвозимыхТоварах.ДатаПоступления МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|СГРУППИРОВАТЬ ПО
		|	СведенияОВвозимыхТоварах.КодСтраны,
		|	СведенияОВвозимыхТоварах.НомерДокумента,
		|	СведенияОВвозимыхТоварах.Дата
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерЗаявления,
		|	ДатаЗаявления";
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("ДатаНачала", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", 	КонецМесяца(Дата));
	
	Приложение2.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

Процедура ЗаполнитьПриложение3()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОВвозимыхТоварах.Номенклатура КАК Номенклатура,
		|	СведенияОВвозимыхТоварах.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СведенияОВвозимыхТоварах.КодТНВЭД КАК КодТНВЭД,
		|	СведенияОВвозимыхТоварах.НомерСтрокиВДокументе КАК НомерСтрокиВЗаявлении,
		|	СведенияОВвозимыхТоварах.НомерДокумента КАК НомерЗаявленияОВвозе,
		|	СведенияОВвозимыхТоварах.Дата КАК ДатаЗаявленияОВвозеТоваров,
		|	СведенияОВвозимыхТоварах.Цена КАК ЦенаЗаЕдТовараПоДоговору,
		|	СведенияОВвозимыхТоварах.Количество КАК КоличествоИмпортированногоТовара
		|ИЗ
		|	РегистрСведений.СведенияОВвозимыхТоварах КАК СведенияОВвозимыхТоварах
		|ГДЕ
		|	СведенияОВвозимыхТоварах.Организация = &Организация
		|	И СведенияОВвозимыхТоварах.ДатаПоступления МЕЖДУ &ДатаНачала И &ДатаОкончания";
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("ДатаНачала", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", 	КонецМесяца(Дата));
	
	Приложение3.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

Процедура ЗаполнитьПриложение4()
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ГумПомощь)
		|			ТОГДА ""350""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Диппредставительства)
		|			ТОГДА ""351""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ПриродныйГаз)
		|			ТОГДА ""352""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ЛекарственныеСредства)
		|			ТОГДА ""353""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СпецтоварыСтекловарения)
		|			ТОГДА ""354""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СельскоеХозяйство)
		|			ТОГДА ""355""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ВоенноеНазначение)
		|			ТОГДА ""356""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Электроэнергия)
		|			ТОГДА ""357""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ККМ)
		|			ТОГДА ""358""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.РеактивноеТопливо)
		|			ТОГДА ""359""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СоцЗначимыеТовары)
		|			ТОГДА ""360""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Прочее)
		|			ТОГДА ""398""
		|	КОНЕЦ КАК КодСтроки,
		|	ТаблицаИмпорт.Ссылка КАК Содержание,
		|	СУММА(НДСНаИмпортОбороты.СуммаОборот) КАК Сумма
		|ИЗ
		|	Перечисление.ИмпортОсвобожденныйОтНДС КАК ТаблицаИмпорт
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.НДСНаИмпорт.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК НДСНаИмпортОбороты
		|		ПО ТаблицаИмпорт.Ссылка = НДСНаИмпортОбороты.ИмпортОсвобожденныйОтНДС
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ГумПомощь)
		|			ТОГДА ""350""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Диппредставительства)
		|			ТОГДА ""351""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ПриродныйГаз)
		|			ТОГДА ""352""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ЛекарственныеСредства)
		|			ТОГДА ""353""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СпецтоварыСтекловарения)
		|			ТОГДА ""354""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СельскоеХозяйство)
		|			ТОГДА ""355""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ВоенноеНазначение)
		|			ТОГДА ""356""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Электроэнергия)
		|			ТОГДА ""357""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ККМ)
		|			ТОГДА ""358""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.РеактивноеТопливо)
		|			ТОГДА ""359""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СоцЗначимыеТовары)
		|			ТОГДА ""360""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Прочее)
		|			ТОГДА ""398""
		|	КОНЕЦ,
		|	ТаблицаИмпорт.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодСтроки";		
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", 	Организация);	

	Приложение4.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "399";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Итого импорт товаров, предусмотренных Налоговым кодексом Кыргызской Республики  и международными договорами (= сумма показателей строк с 350 по 398)'");
	СтрокаТабличнойЧасти.Сумма = Приложение4.Итог("Сумма");	
КонецПроцедуры

Процедура ЗаполнитьПриложение5()

	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "401";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Спирт, алкогольные и спиртосодержащие товары'");	

	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "402";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Табачная продукция'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "403";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Масла и другие продукты высокотемпературной перегонки каменноугольной смолы; аналогичные продукты, в которых масса ароматических составных частей превышает массу неароматических:бензол для использования в качестве топлива'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "404";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Газовый конденсат природный: газовый конденсат стабильной плотности при 20 C Не более 650 кг/м3, но не более 850 кг/м3 и с содержанием серы не более 1,0мас%, прочий'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "405";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Нефть сырая и нефтепродукты сырые, полученные из битуминозных материалов'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "406";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Бензины моторные, специальные, легкие и средние дистилляты за исключением классифицируемых в товарной позиции ТН ВЭД 2710 19 290, прочие бензины и дистилляты'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "407";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Прочие нефтепродукты (биотопливо,топливо экологическое, смесь легких дистиллятов)'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "408";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Топливо для  реактивных двигателей'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "409";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Дизельное топливо, газойли, тяжелые дистилляты, средние дистилляты, классифицируемые в товарной позиции ТНВЭД 2710 19 290'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "410";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Мазут'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "411";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Масла смазочные, масла прочие'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "412";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Прочие антидетонаторы на основе соединений свинца, используемым в тех же целях, что и нефтепродукты'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "413";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Присадки к смазочным маслам, содержащие нефть или нефтепродукты, полученные из битуминозных пород'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "421";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сумма акцизного налога, внесенная на специальный счет налогового органа (депозит)'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "422";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сумма депозита, не подтвержденная документально'");
	
	СтрокаТабличнойЧасти = Приложение5.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "423";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сумма депозита, подлежащая возврату налогоплательщику'");
КонецПроцедуры

Процедура ЗаполнитьПриложение9()

	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "901";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Спирт, алкогольные и спиртосодержащие товары'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2203 - 2208";

	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "902";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Табачная продукция'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2402, 8543400000 2403, 2404";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "903";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Масла и другие продукты высокотемпературной перегонки каменноугольной смолы; аналогичные продукты, в которых масса ароматических составных частей превышает массу неароматических:бензол для использования в качестве топлива'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2707101000";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "904";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Газовый конденсат природный: газовый конденсат стабильной плотности при 20 C Не более 650 кг/м3, но не более 850 кг/м3 и с содержанием серы не более 1,0мас%, прочий'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2709001001, 2709001009";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "905";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Нефть сырая и нефтепродукты сырые, полученные из битуминозных материалов'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2709009001-2709009009";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "906";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Бензины моторные, специальные, легкие и средние дистилляты за исключением классифицируемых в товарной позиции ТН ВЭД 2710 19 290, прочие бензины и дистилляты'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710121100-2710129000, 2710191100-2710191500, 2710192500";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "907";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Прочие нефтепродукты (биотопливо,топливо экологическое, смесь легких дистиллятов)'");
	СтрокаТабличнойЧасти.КодТНВЭД = "27102090000";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "908";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Топливо для  реактивных двигателей'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710192100";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "909";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Нефть сырая и нефтепродукты сырые, полученные из битуминозных материалов'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710192900; 2710193100-2710194800; 2710201100-2710201900";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "910";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Дизельное топливо, газойли, тяжелые дистилляты, средние дистилляты, классифицируемые в товарной позиции ТНВЭД 2710 19 290'");
	СтрокаТабличнойЧасти.КодТНВЭД = " 2710195100-2710196809, 2710203101-2710203909";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "911";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Масла смазочные, масла прочие'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710197100-2710199800";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "912";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Прочие антидетонаторы на основе соединений свинца, используемым в тех же целях, что и нефтепродукты'");
	СтрокаТабличнойЧасти.КодТНВЭД = "3811119000; 3811190000";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.КодСтроки = "913";
	СтрокаТабличнойЧасти.Наименование = НСтр("ru = 'Присадки к смазочным маслам, содержащие нефть или нефтепродукты, полученные из битуминозных пород'");
	СтрокаТабличнойЧасти.КодТНВЭД = "3811210000";
КонецПроцедуры

Процедура ЗаполнитьОсновнаяФорма()
	
	// Заполнение "050" и "051".
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("КодСтроки", "199");	
	МассивСтрок = Приложение1.НайтиСтроки(ПараметрыОтбора);
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 	= "050";                       	
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Стоимость облагаемого импорта'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].Сумма, 0);

	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 	= "051";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Сумма НДС на импорт'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].СуммаНДС, 0);
	
	// Заполнение "052".
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("КодСтроки", "399");	
	МассивСтрок = Приложение4.НайтиСтроки(ПараметрыОтбора);
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 	= "052";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Стоимость импорта, освобожденного от НДС'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].Сумма, 0);
	
	// Заполнение "053".
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("КодСтроки", "420");	
	МассивСтрок = Приложение5.НайтиСтроки(ПараметрыОтбора);
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 	= "053";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Сумма акциза на импорт'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].СуммаАкциза, 0);
	
	// Заполнение "054".
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 	= "054";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Стоимость импорта, подакцизных товаров, освобожденных от акциза'");
	СтрокаТабличнойЧасти.Сумма = Приложение9.Итог("СтоимостьИмпортированныхПодакцизныхТоваров");
	
	// Заполнение "055".
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 	= "055";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Сумма условного начисления НДС на импорт'");
	СтрокаТабличнойЧасти.Сумма = Приложение10.Итог("СуммаУсловногоНачисленияНДС");
		
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.КодСтроки 	= "056";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Документы, прилагаемые к отчету'");
	СтрокаТабличнойЧасти.Сумма = 0;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли