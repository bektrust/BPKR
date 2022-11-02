////////////////////////////////////////////////////////////////////////////////
// Общий модуль Тарификация.

// Получение/освобождение лицензий на уникальные услуги выполняется в два этапа:
// 1) Сначала выполняется запрос на получение/освобождение лицензии (например, в начале транзакции),
//    при этом системе тарификации передается уникальный идентификатор операции.
// 2) Затем выполняется либо подтверждение, либо отмена ранее запрошенной операции
//    (например, перед завершением транзакции).
//
// Важно! "Время жизни" незавершенной операции в системе тарификации БТС составляет 15 минут,
// по истечении этого времени незавершенные операции автоматически отменяются.

#Область ПрограммныйИнтерфейс

// Возвращает ссылку на услугу по ее идентификатору и идентификатору поставщика услуги.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторУслуги - Строка - идентификатор услуги.
//  ИдентификаторПоставщика - Строка - идентификатор поставщика.
//	ВызыватьИсключение - Булево - флаг необходимости вызвать исключение в случае если услуга не найдена
//
// Возвращаемое значение:
//  СправочникСсылка.УслугиСервиса - ссылка на услугу.
//
Функция УслугаПоИдентификаторуИИдентификаторуПоставщика(Знач ИдентификаторУслуги, Знач ИдентификаторПоставщика, ВызыватьИсключение = Истина) Экспорт
КонецФункции

// Проверяет, позволяет ли система тарификации сервиса использование указанной безлимитной услуге
// указанному пользователю.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//
// Возвращаемое значение:
//  Булево - результат проверки (Истина = лицензия зарегистрирована).
//
Функция ЗарегистрированаЛицензияБезлимитнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги) Экспорт
КонецФункции

// Проверяет, зарегистрирован ли в системе тарификации сервиса указанный идентификатор
// лицензии на использование указанной уникальной лимитированной услуги.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//  ИмяЛицензии - Строка - Строка(200) уникальное строковое представление лицензии, ПОНЯТНОЕ ПОЛЬЗОВАТЕЛЮ.
//  КонтекстЛицензии - Строка - Строка (200), контекст лицензии.
//
// Возвращаемое значение:
//  Булево - результат проверки (Истина = лицензия зарегистрирована).
//
Функция ЗарегистрированаЛицензияУникальнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги, ИмяЛицензии, КонтекстЛицензии = "") Экспорт
КонецФункции

// Выполняет попытку получить лицензию на использование уникальной услуги в системе тарификации сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//  ИмяЛицензии - Строка - Строка(200) уникальное строковое представление лицензии, ПОНЯТНОЕ ПОЛЬЗОВАТЕЛЮ.
//  ИдентификаторОперации - УникальныйИдентификатор - уникальный идентификатор операции, потребуется для подтверждения.
//  КонтекстЛицензии - Строка - Строка(200) контекст лицензия, указывающий уникальность лицензии.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * Результат - Булево - результат выполнения (Истина = лицензия успешно получена).
//    * ДоступноЛицензий - Число - максимально доступное абоненту количество лицензий на указанную услугу (если "-1", значит неограниченное количество).
//    * ЗанятоЛицензий - Число - количество уже полученных (использованных) лицензий на услугу.
//    * СвободноЛицензий - Число - количество свободных лицензий (если "-1", значит неограниченное количество).
//
Функция ЗанятьЛицензиюУникальнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги, ИмяЛицензии, ИдентификаторОперации, КонтекстЛицензии = "") Экспорт
КонецФункции

// Выполняет попытку освободить лицензию на уникальную услугу в системе тарификации сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//  ИмяЛицензии - Строка - Строка(200) уникальное строковое представление лицензии, ПОНЯТНОЕ ПОЛЬЗОВАТЕЛЮ.
//  ИдентификаторОперации - УникальныйИдентификатор - уникальный идентификатор операции, потребуется для подтверждения.
//  КодОбластиДанных - Число - код области данных (если мы вызываем функцию из неразделенного сеанса).
//  КонтекстЛицензии - Строка - Строка(200) контекст лицензия, указывающий уникальность лицензии.
//  УдалитьЛицензиюВоВсехОбластяхДанных - Булево - удалять или нет данную лицензию по областям данных.
//
// Возвращаемое значение:
//  Булево - результат выполнения (Истина = лицензия успешно освобождена, Ложь - данная лицензия не была найдена).
//
Функция ОсвободитьЛицензиюУникальнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги, ИмяЛицензии, 
	ИдентификаторОперации, КодОбластиДанных = Неопределено,
	КонтекстЛицензии = "", УдалитьЛицензиюВоВсехОбластяхДанных = Ложь) Экспорт
КонецФункции

// Выполняет попытку получить лицензии на использование лимитированной услуги в сервисе.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//  КоличествоЛицензий - Число - требуемое количество лицензий (натуральное число, 10 разрядов).
//  КодОбластиДанных - Число - код области данных (если мы вызываем функцию из неразделенного сеанса).
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * Результат - Булево - результат выполнения (Истина = лицензия успешно получена).
//    * ДоступноЛицензий - Число - максимально доступное абоненту количество лицензий на указанную услугу (если "-1", значит неограниченное количество).
//    * ЗанятоЛицензий - Число - количество уже полученных (использованных) лицензий на услугу.
//    * СвободноЛицензий - Число - количество свободных лицензий (если "-1", значит неограниченное количество).
//
Функция ЗанятьЛицензииЛимитированнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги, КоличествоЛицензий, КодОбластиДанных = Неопределено) Экспорт
КонецФункции

// Выполняет попытку освободить лицензии на использование лимитированной услуги в сервисе.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//  КоличествоЛицензий - Число - требуемое количество лицензий (натуральное число, 10 разрядов).
//  КодОбластиДанных - Число - код области данных (если мы вызываем функцию из неразделенного сеанса).
//
// Возвращаемое значение:
//  Булево - результат выполнения (Истина = лицензия успешно освобождена).
//
Функция ОсвободитьЛицензииЛимитированнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги, КоличествоЛицензий, КодОбластиДанных = Неопределено) Экспорт
КонецФункции

// Выполняет подтверждение ранее запрошенной операции с лицензиями (получение или освобождение).
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторОперации - УникальныйИдентификатор - идентификатор операции, который передавался при запросе операции.
//
// Возвращаемое значение:
//  Булево - результат операции (Истина = операция подтверждена).
//
Функция ПодтвердитьОперацию(ИдентификаторОперации) Экспорт
КонецФункции

// Выполняет отмену ранее запрошенной операции с лицензиями (получение или освобождение).
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторОперации - УникальныйИдентификатор - идентификатор операции, который передавался при запросе операции.
//
// Возвращаемое значение:
//    Булево - результат операции (Истина = операция отменена).
//
Функция ОтменитьОперацию(ИдентификаторОперации) Экспорт
КонецФункции

// Выполняет попытку получить количество свободных лицензий на использование уникальной услуги в системе тарификации сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//
// Возвращаемое значение:
//  Структура - с ключами:
//    * ДоступноЛицензий - Число - максимально доступное абоненту количество лицензий на указанную услугу (если "-1", значит неограниченное количество).
//    * ЗанятоЛицензий - Число - количество уже полученных (использованных) лицензий на услугу.
//    * СвободноЛицензий - Число - количество свободных лицензий (если "-1", значит неограниченное количество).
//
Функция КоличествоЛицензийУникальнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги) Экспорт
КонецФункции

// Выполняет попытку получить количество лицензий лимитированной услуги в сервисе.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторПоставщика - Строка - уникальный строковый идентификатор (код) поставщика услуг в сервисе.
//  ИдентификаторУслуги - Строка - уникальный строковый идентификатор (код) услуги в сервисе.
//  КодОбластиДанных - Число - код области данных (если мы вызываем функцию из неразделенного сеанса).
//
// Возвращаемое значение:
//  Структура - с ключами:
//    * ДоступноЛицензий - Число - максимально доступное абоненту количество лицензий на указанную услугу (если "-1", значит неограниченное количество).
//    * ЗанятоЛицензий - Число - количество уже полученных (использованных) лицензий на услугу.
//    * СвободноЛицензий - Число - количество свободных лицензий (если "-1", значит неограниченное количество).
//
Функция КоличествоЛицензийЛимитированнойУслуги(ИдентификаторПоставщика, ИдентификаторУслуги, КодОбластиДанных = Неопределено) Экспорт
КонецФункции

// Возвращает признак блокировки текущего сеанса тарификацией.
// 
// Возвращаемое значение:
//  Булево -
Функция ТекущийСеансЗаблокирован() Экспорт
	Возврат Ложь;	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// 
// Параметры:
// 	Типы - См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
// 
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ДоступныеЛицензии);
	Типы.Добавить(Метаданные.РегистрыСведений.ЗанятыеЛицензии);
	
	ВыгрузкаЗагрузкаДанных.ДополнитьТипомИсключаемымИзВыгрузкиЗагрузки(
		Типы,
		Метаданные.Справочники.УслугиСервиса,
		ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеИзменять());	
	
	ВыгрузкаЗагрузкаДанных.ДополнитьТипомИсключаемымИзВыгрузкиЗагрузки(
		Типы,
		Метаданные.Справочники.ПоставщикиУслугСервиса,
		ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеИзменять());	

	Типы.Добавить(Метаданные.Константы.ИспользоватьКонтрольТарификации);
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	Настройки - см. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.Настройки
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	МассивОбработчиков - См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений.МассивОбработчиков
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиОтправляемыхСообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	МассивОбработчиков - См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиОтправляемыхСообщений.МассивОбработчиков
//
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт
КонецПроцедуры

// Обработчик события "ПриУстановкеКонечнойТочкиМенеджераСервиса".
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриУстановкеКонечнойТочкиМенеджераСервиса() Экспорт
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
КонецПроцедуры

// Регистрирует в МС тарифицируемые услуги, которые поддерживает данная конфигурация.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ЗарегистрироватьТарифицируемыеУслуги_РегламентноеЗадание() Экспорт
КонецПроцедуры

// Пытается запросить у Менеджера сервиса лицензии уникальных услуг.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ЗапроситьЛицензииУникальныхУслуг_РегламентноеЗадание() Экспорт
КонецПроцедуры

// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ОбработкаПолученияФормы(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
КонецПроцедуры

#КонецОбласти
