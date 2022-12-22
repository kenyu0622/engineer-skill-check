# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

DEPARTMENT_NAME = %w[総務部 技術部 営業部]
OFFICE_NAME = %w[東京 仙台 大阪 福岡 大分]

DEPARTMENT_NAME.each.with_index(1) { |department, i| Department.find_or_create_by(id: i, name: department) }
OFFICE_NAME.each.with_index(1) { |office, i| Office.find_or_create_by(id: i, name: office) }
Employee.find_or_create_by(id: 1, department_id: Department.find_by(name: '総務部').id,
                           office_id: Office.find_by(name: '東京').id,
                           number: '1', last_name: '山田', first_name: '太郎', account: 'yamada',
                           password: 'hogehoge', email: 'yamada@example.co.jp', date_of_joining: '1991/4/1',
                           employee_info_manage_auth: true, news_posting_auth: true)
