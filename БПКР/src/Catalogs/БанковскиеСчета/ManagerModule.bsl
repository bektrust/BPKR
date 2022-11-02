#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Владелец");
	БлокируемыеРеквизиты.Добавить("Банк");
	БлокируемыеРеквизиты.Добавить("ВалютаДенежныхСредств");
	БлокируемыеРеквизиты.Добавить("СчетУчета");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции 

// Функция - Найти по номеру счета
//
// Параметры:
//  НомерСчета				 - Строка	 - 
//  Владелец				 - СправочникСсылка.Контрагент	 - 
//  ВалютаДенежныхСредств	 - СправочникСсылка.Валюты	 - 
// 
// Возвращаемое значение:
//  БанковскийСчет - СправочникСсылка.БанковскиеСчета - найденный банковский счет 
//
Функция НайтиПоНомеруСчета(НомерСчета, Владелец, ВалютаДенежныхСредств) Экспорт
	БанковскийСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	БанковскиеСчета.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Владелец = &Владелец
		|	И БанковскиеСчета.НомерСчета = &НомерСчета
		|	И БанковскиеСчета.ВалютаДенежныхСредств = &ВалютаДенежныхСредств";
	
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", ВалютаДенежныхСредств);
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("НомерСчета", НомерСчета);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		БанковскийСчет = ВыборкаДетальныеЗаписи.Ссылка;		
	КонецЕсли;
	
	Возврат БанковскийСчет;	
КонецФункции

// Получает банковский счет по умолчанию с учетом условий отбора. Возвращается основной банковский счет или единственный
// или пустую ссылку.
//
// Параметры
//  Организация	-	<СправочникСсылка.Организации> 
//							Организация, банковский счет которой нужно получить
//  ВалютаДокумента	-	<СправочникСсылка.Валюты> 
//							Валюта банковского счета
//
// Возвращаемое значение:
//   <СправочникСсылка.БанковскиеСчета> - найденный банковский счет или пустая ссылка
//
Функция ПолучитьБанковскийСчетПоУмолчаниюПоОрганизацииВалюте(Организация, ВалютаДокумента) Экспорт
	
	ОсновнойОсновнойБанковскийСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Организации.ОсновнойБанковскийСчет.ВалютаДенежныхСредств = &ВалютаДокумента
		|			ТОГДА Организации.ОсновнойБанковскийСчет
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК БанковскийСчет
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		ОсновнойОсновнойБанковскийСчет = ВыборкаДетальныеЗаписи.БанковскийСчет;
	КонецЕсли;
	
	Возврат ОсновнойОсновнойБанковскийСчет;

КонецФункции // ПолучитьБанковскийСчетПоУмолчаниюПоОрганизацииВалюте()

#КонецОбласти

#КонецЕсли