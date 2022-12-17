class EmployeesController < ApplicationController
  before_action :set_employee, only: %i(edit update destroy)
  before_action :set_form_option, only: %i(new create edit update)

  def index
    @employees = Employee.active.order("#{sort_column} #{sort_direction}").page(params[:page])
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      redirect_to employees_url, notice: "社員「#{@employee.last_name} #{@employee.first_name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_url, notice: "社員「#{@employee.last_name} #{@employee.first_name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      now = Time.now
      @employee.update_column(:deleted_at, now)
      @employee.profiles.active.first.update_column(:deleted_at, now) if @employee.profiles.active.present?
    end

    redirect_to employees_url, notice: "社員「#{@employee.last_name} #{@employee.first_name}」を削除しました。"
  end

  def export
    employee_attributes = params[:employee_attributes]
    employees = Employee.all

    _csv_str = CSV.generate do |csv|
      # Head部分
      head = %w[ID 削除日]
      if employee_attributes.present?
        employee_attributes.each do |attribute|
          head.push Employee.human_attribute_name(attribute.to_sym)
        end
      end
      csv << head

      # row
      employees.each do |employee|
        row = [employee.id, employee.deleted_at]
        if employee_attributes.present?
          employee_attributes.each do |attribute|
            case employee.send(attribute)
            when true
              row.push '1'
            when false
              row.push ''
            else
              row.push employee.send(attribute)
            end
          end
        end
        csv << row
      end
    end

    csv_str = NKF.nkf('--sjis -Lw', _csv_str)
    send_data csv_str,
              filename: '社員情報.csv',
              type: 'text/csv'
  end

  def upload
    file_path = params[:file_path].try(:tempfile).try(:path)
    return if file_path.blank?

    @employees = []
    csv_data = params[:file_path].try(:tempfile).read
    # 文字コードをUTF-8に統一する
    csv_data = NKF.nkf('-w', csv_data)
    CSV.new(csv_data, headers: true).each do |row|
      data = row.to_hash

      # IDが入力されていたら更新、未入力の場合は新規作成
      if data['ID'].present?
        employee = Employee.find_by(id: data['ID'])
        next if employee.blank?

        _number = employee.number
        _last_name = employee.last_name
        _first_name = employee.first_name
        _account = employee.account
        _password = employee.password
        _email = employee.email
        _date_of_joining = employee.date_of_joining
        _department_id = employee.department_id
        _office_id = employee.office_id
        _news_posting_auth = employee.news_posting_auth
        _employee_info_manage_auth = employee.employee_info_manage_auth
        _deleted_at = employee.deleted_at
      else
        _number = nil
        _last_name = nil
        _first_name = nil
        _account = nil
        _password = nil
        _email = nil
        _date_of_joining = nil
        _department_id = nil
        _office_id = nil
        _news_posting_auth = false
        _employee_info_manage_auth = false
        _deleted_at = nil
      end

      _number = data['社員番号'] if data.keys.include?('社員番号')
      _last_name = data['氏名（姓）'] if data.keys.include?('氏名（姓）')
      _first_name = data['氏名（名）'] if data.keys.include?('氏名（名）')
      _account = data['アカウント'] if data.keys.include?('アカウント')
      _password = data['パスワード'] if data.keys.include?('パスワード')
      _email = data['メールアドレス'] if data.keys.include?('メールアドレス')
      _date_of_joining = data['入社年月日'] if data.keys.include?('入社年月日')
      _department_id = data['部署'].to_i if data.keys.include?('部署')
      _office_id = data['オフィス'].to_i if data.keys.include?('オフィス')
      _employee_info_manage_auth = data['社員情報管理権限'] == '1' if data.keys.include?('社員情報管理権限')
      _news_posting_auth = data['お知らせ投稿権限'] == '1' if data.keys.include?('お知らせ投稿権限')
      if data.keys.include?('削除日')
        if data['削除日'] == 'D'
          _deleted_at = Time.now if _deleted_at.blank?
        elsif data['削除日'].blank?
          _deleted_at = nil
        end
      end

      if data['ID'].present?
        @employees.push employee if employee.update(
          number: _number,
          last_name: _last_name,
          first_name: _first_name,
          account: _account,
          password: _password,
          email: _email,
          date_of_joining: _date_of_joining,
          department_id: _department_id,
          office_id: _office_id,
          employee_info_manage_auth: _employee_info_manage_auth,
          news_posting_auth: _news_posting_auth,
          deleted_at: _deleted_at
        )
      else
        employee = Employee.new(
          number: _number,
          last_name: _last_name,
          first_name: _first_name,
          account: _account,
          password: _password,
          email: _email,
          date_of_joining: _date_of_joining,
          department_id: _department_id,
          office_id: _office_id,
          employee_info_manage_auth: _employee_info_manage_auth,
          news_posting_auth: _news_posting_auth,
          deleted_at: _deleted_at
        )
        @employees.push employee if employee.save
      end
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:number, :last_name, :first_name, :account, :password, :email, :date_of_joining, :department_id, :office_id, :employee_info_manage_auth, :news_posting_auth)
  end

  def set_employee
    @employee = Employee.find(params["id"])
  end

  def set_form_option
    @departments = Department.all
    @offices = Office.all
  end

  def sort_column
    params[:sort] ? params[:sort] : 'number'
  end

  def sort_direction
    params[:direction] ? params[:direction] : 'asc'
  end

end
