#Область ПрограммныйИнтерфейс

Процедура ОбновитьНаборЗаписейИстории(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	Если Не Форма[ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
		
		Форма.ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект);
		
	КонецЕсли;
	
	ОбновитьНаборЗаписейИсторииВФорме(Форма, ИмяРегистра);
	
КонецПроцедуры

Процедура ОбновитьНаборЗаписейИсторииПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	Если Не Форма[ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
		
		Форма.ПрочитатьНаборЗаписейПериодическихСведенийПоСтруктуре(ИмяРегистра, СтруктураВедущихОбъектов);
		
	КонецЕсли;
	
	ОбновитьНаборЗаписейИсторииВФорме(Форма, ИмяРегистра);
	
КонецПроцедуры

Функция ЗаполненыЗначенияПоУмолчаниюПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	ЗначенияПоУмолчанию = Истина;
	Для Каждого КлючЗначение Из Форма[ИмяРегистра + "Прежняя"] Цикл
		// Допущение, что если значение поля - ведущий объект, то это - измерение регистра
		// Значит, что если даже в ресурсе содержится значение с тем же типом, что и ведущий объект, то 
		// такое значение ресурса является значением по умолчанию
		ВедущийОбъект = Неопределено;
		СтруктураВедущихОбъектов.Свойство(КлючЗначение.Ключ, ВедущийОбъект);
		Если ВедущийОбъект = Форма[ИмяРегистра][КлючЗначение.Ключ] Тогда
			Продолжить;
		КонецЕсли;
		// Допущение, значения типа Булево невозможно проверить на заполненность
		Если ТипЗнч(Форма[ИмяРегистра][КлючЗначение.Ключ]) = Тип("Булево") Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(Форма[ИмяРегистра][КлючЗначение.Ключ]) Тогда
			ЗначенияПоУмолчанию = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЗначенияПоУмолчанию;
	
КонецФункции

Процедура ОбновитьОтображениеПолейВвода(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	СтруктураВедущихОбъектов = Новый Структура();
	Для Каждого КлючЗначение Из Форма[ИмяРегистра + "Прежняя"] Цикл
		Если ВедущийОбъект = Форма[ИмяРегистра][КлючЗначение.Ключ] Тогда
			СтруктураВедущихОбъектов.Вставить(КлючЗначение.Ключ, ВедущийОбъект);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьОтображениеПолейВводаПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
КонецПроцедуры

Процедура ОбновитьОтображениеПолейВводаПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	// Если регистр не периодический - ничего не делаем
	Если НЕ Форма[ИмяРегистра].Свойство("Период") Тогда
		Возврат;
	КонецЕсли;
	
	// Для периода, редактируемого строкой
	ЭлементПериод = Форма.Элементы.Найти(ИмяРегистра + "ПериодСтрокой");
	
	// Если на форме не оказалось элемента редактирования периода строкой
	// ищем поле редактирования периода датой
	Если ЭлементПериод = Неопределено Тогда
		ЭлементПериод = Форма.Элементы.Найти(ИмяРегистра + "Период");
	КонецЕсли;
	
	// Если на форме не размещено поле редактирования периода - ничего не делаем
	Если ЭлементПериод = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Не обязательно заполнение поля Период если данные - по умолчанию и при этом 
	// записей регистра еще нет
	ЗначенияПоУмолчанию = ЗаполненыЗначенияПоУмолчаниюПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	ЕстьЗаписи = ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"].Период);
	
	Если ЗначенияПоУмолчанию И Не ЕстьЗаписи Тогда
		ЭлементПериод.АвтоОтметкаНезаполненного = Ложь;
		ЭлементПериод.ОтметкаНезаполненного = Ложь;
	Иначе
		ЭлементПериод.АвтоОтметкаНезаполненного = Истина;
		Если ЗначениеЗаполнено(Форма[ИмяРегистра].Период) Тогда
			ЭлементПериод.ОтметкаНезаполненного = Ложь;
		Иначе
			ЭлементПериод.ОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьНаборЗаписейИсторииВФорме(Форма, ИмяРегистра)
Перем ЗаписьНабора;
	
	СтруктураЗаписиСтрокой = "";
	ПрежняяЗапись = Новый Структура;
	НужнаЗапятая = Ложь;
	Для Каждого КлючЗначение Из Форма[ИмяРегистра + "Прежняя"] Цикл
		Если НужнаЗапятая Тогда
			СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + ",";
		КонецЕсли;
		СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + КлючЗначение.Ключ;
		НужнаЗапятая = Истина;
		ПрежняяЗапись.Вставить(КлючЗначение.Ключ);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Форма[ИмяРегистра].Период) Тогда
		ПериодИзменен = Форма[ИмяРегистра].Период <> Форма[ИмяРегистра + "Прежняя"].Период;
		РесурсыИзменены = Ложь;
		Для Каждого КлючЗначение Из Форма[ИмяРегистра + "Прежняя"] Цикл
			Если КлючЗначение.Ключ = "Период" Тогда
				Продолжить;
			КонецЕсли;
			Если КлючЗначение.Значение <> Форма[ИмяРегистра][КлючЗначение.Ключ] Тогда
				РесурсыИзменены = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		НаборЗаписей = Форма[ИмяРегистра + "НаборЗаписей"];
		Если (ПериодИзменен И РесурсыИзменены) ИЛИ НаборЗаписей.Количество() = 0 Тогда
			ЗаписьНаНовуюДату = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Форма[ИмяРегистра].Период));
			Если ЗаписьНаНовуюДату.Количество() = 0 Тогда
				ЗаписьНабора = НаборЗаписей.Добавить();
			КонецЕсли;
			Если НЕ Форма[ИмяРегистра + "НоваяЗапись"] И ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"].Период) Тогда
				ПредыдущаяЗапись = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Форма[ИмяРегистра + "Прежняя"].Период));
				Если ПредыдущаяЗапись.Количество() > 0 Тогда
					НаборЗаписей.Удалить(ПредыдущаяЗапись[0]);
				КонецЕсли; 
			КонецЕсли; 
		Иначе
			ЗаписьНабора = НаборЗаписей[НаборЗаписей.Количество() - 1];
			Если ЗаписьНабора.Период <> Форма[ИмяРегистра].Период Тогда
				ЗаписьНаНовуюДату = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Форма[ИмяРегистра].Период));
				Если ЗаписьНаНовуюДату.Количество() > 0 Тогда
					НаборЗаписей.Удалить(ЗаписьНаНовуюДату[0]);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ЗаписьНабора <> НеОпределено Тогда
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, Форма[ИмяРегистра]);
			НаборЗаписей.Сортировать("Период");
			
			ЗаполнитьЗначенияСвойств(Форма[ИмяРегистра], НаборЗаписей[НаборЗаписей.Количество() - 1]);
			ЗаполнитьЗначенияСвойств(ПрежняяЗапись, Форма[ИмяРегистра]);
			Форма[ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(ПрежняяЗапись);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
